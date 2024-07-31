extends Node3D

@export var room_number : int = 4
@export_range(0,1) var survival_chance : float = 0.25
@export var room_margin : int = 1
@export var room_recursion : int = 15
@export var min_room_size : int = 4
@export var max_room_size : int = 7
@export var seed_value: int = 0
@export var border_size : int = 20

@onready var grid_map : GridMap = $GridMap
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
const DunCell = preload("res://imports/DunCell.gd")
var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []
var dun_cell_scene : PackedScene = preload("res://imports/DunCell.tscn")

@onready var ui_scene : PackedScene = preload("res://3D Dungeon/UI.tscn")
@onready var ui_instance : Control = ui_scene.instantiate()
@onready var survival_chance_input : SpinBox = ui_instance.get_node("VBoxContainer/SurvivalChanceInput")
@onready var border_size_input : SpinBox = ui_instance.get_node("VBoxContainer/BorderSizeInput")
@onready var room_number_input : SpinBox = ui_instance.get_node("VBoxContainer/RoomNumberInput")
@onready var room_margin_input : SpinBox = ui_instance.get_node("VBoxContainer/RoomMarginInput")
@onready var room_recursion_input : SpinBox = ui_instance.get_node("VBoxContainer/RoomRecursionInput")
@onready var min_room_size_input : SpinBox = ui_instance.get_node("VBoxContainer/MinRoomSizeInput")
@onready var max_room_size_input : SpinBox = ui_instance.get_node("VBoxContainer/MaxRoomSizeInput")
@onready var custom_seed_input : LineEdit = ui_instance.get_node("VBoxContainer/CustomSeedInput")
@onready var start_button : Button = ui_instance.get_node("VBoxContainer/StartButton")
@onready var home_button : Button = ui_instance.get_node("VBoxContainer/HomeButton")  


var directions : Dictionary = {
	"up" : Vector3i.FORWARD, "down" : Vector3i.BACK,
	"left" : Vector3i.LEFT, "right" : Vector3i.RIGHT
}

func _ready():
	add_child(ui_instance)
	setup_ui()

func setup_ui():
	survival_chance_input.value = 0.25
	border_size_input.value = border_size
	room_number_input.value = room_number
	room_margin_input.value = room_margin
	room_recursion_input.value = room_recursion
	min_room_size_input.value = min_room_size
	max_room_size_input.value = max_room_size
	custom_seed_input.text = str(seed_value)
	
	start_button.connect("pressed", Callable(self, "on_start_button_pressed"))
	home_button.connect("pressed", Callable(self, "_on_home_button_pressed"))  


func on_start_button_pressed():
	survival_chance = survival_chance_input.value
	border_size = int(border_size_input.value)
	room_number = int(room_number_input.value)
	room_margin = int(room_margin_input.value)
	room_recursion = int(room_recursion_input.value)
	min_room_size = int(min_room_size_input.value)
	max_room_size = int(max_room_size_input.value)
	
	# Generate a new random seed each time the button is pressed
	seed_value = rng.randi()
	custom_seed_input.text = str(seed_value)
	
	generate()

func _on_home_button_pressed():  
	get_tree().change_scene_to_file("res://main_scene.tscn")

func setup_seed():
	rng.seed = seed_value
	print("Using seed: ", seed_value)

func visualize_border():
	if grid_map == null:
		print("GridMap is null!")
		return
	grid_map.clear()
	for i in range (-1,border_size+1):
		grid_map.set_cell_item(Vector3i(i,0,-1), 3)
		grid_map.set_cell_item(Vector3i(i,0,border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size,0,i), 3)
		grid_map.set_cell_item(Vector3i(-1,0,i), 3)

func create_hallways(hallway_graph:AStar2D):
	var hallways : Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var room_from : PackedVector3Array = room_tiles[p]
				var room_to : PackedVector3Array = room_tiles[c]
				var tile_from : Vector3 = room_from[0]
				var tile_to : Vector3 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c])<\
					tile_to.distance_squared_to(room_positions[c]):
						tile_from = t
				
				for t in room_to:
					if t.distance_squared_to(room_positions[p])<\
					tile_to.distance_squared_to(room_positions[p]):
						tile_to = t
						
				var hallway : PackedVector3Array = [tile_from,tile_to]
				hallways.append(hallway)
				grid_map.set_cell_item(tile_from,2)
				grid_map.set_cell_item(tile_to,2)
				
	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * border_size
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	for t in grid_map.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x,t.z))
	
	for h in hallways:
		var pos_from : Vector2i = Vector2i(h[0].x,h[0].z)
		var pos_to : Vector2i = Vector2i(h[1].x,h[1].z)
		var hall : PackedVector2Array = astar.get_point_path(pos_from,pos_to)
		
		for t in hall:
			var pos : Vector3i = Vector3i(t.x,0,t.y)
			if grid_map.get_cell_item(pos) < 0:
				grid_map.set_cell_item(pos,1)

func handle_none(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_00(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_01(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_02(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_10(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_11(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_12(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_20(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_21(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
func handle_22(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)

func create_dungeon():
	for c in get_children():
		if c != grid_map and c != ui_instance:  # Keep the GridMap and UI, remove other children
			remove_child(c)
			c.queue_free()
	
	var t : int = 0
	for cell in grid_map.get_used_cells():
		var cell_index : int = grid_map.get_cell_item(cell)
		if cell_index != -1 and cell_index != 3:
			var dun_cell : Node3D = dun_cell_scene.instantiate()
			dun_cell.position = Vector3(cell) + Vector3(0.5, 0, 0.5)
			add_child(dun_cell)
			dun_cell.set_owner(owner)
			t += 1
			
			for i in 4:
				var cell_n : Vector3i = cell + directions.values()[i]
				var cell_n_index : int = grid_map.get_cell_item(cell_n)
				if cell_n_index == -1 or cell_n_index == 3:
					handle_none(dun_cell, directions.keys()[i])
				else:
					var key : String = str(cell_index) + str(cell_n_index)
					if has_method("handle_" + key):
						call("handle_" + key, dun_cell, directions.keys()[i])
					else:
						print("Warning: No handler for cell configuration ", key)
		if t % 10 == 9:
			await get_tree().create_timer(0).timeout

func generate():
	if grid_map == null:
		print("GridMap is null in generate!")
		return
	
	# Clear existing dungeon
	grid_map.clear()
	for c in get_children():
		if c != grid_map and c != ui_instance:
			remove_child(c)
			c.queue_free()
	
	setup_seed()
	room_tiles.clear()
	room_positions.clear()
	visualize_border()
	for i in room_number:
		make_room(room_recursion)
	print(room_positions)
	
	var rpv2: PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()
	
	for p in room_positions:
		rpv2.append(Vector2(p.x,p.z))
		del_graph.add_point(del_graph.get_available_point_id(), Vector2(p.x,p.z))
		mst_graph.add_point(mst_graph.get_available_point_id(), Vector2(p.x,p.z))
		
	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(rpv2))
	
	for i in delaunay.size()/3:
		var p1 : int = delaunay.pop_front()
		var p2 : int = delaunay.pop_front()
		var p3 : int = delaunay.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)
	
	var visited_points : PackedInt32Array = []
	visited_points.append(rng.randi() % room_positions.size())
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con : PackedInt32Array = [vp,c]
					possible_connections.append(con)
		
		var connection : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) <\
			rpv2[connection[0]].distance_squared_to(rpv2[connection[1]]):
				connection = pc
				
		visited_points.append(connection[1])
		mst_graph.connect_points(connection[0], connection[1])
		del_graph.disconnect_points(connection[0], connection[1])
	
	var hallway_graph : AStar2D = mst_graph
	
	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c>p:
				var kill : float = rng.randf()
				if survival_chance > kill :
					hallway_graph.connect_points(p,c)
					
	create_hallways(hallway_graph)
	create_dungeon()

func make_room(rec:int):
	if grid_map == null:
		print("GridMap is null in make_room!")
		return
	
	if !rec>0:
		return
	
	var width : int = (rng.randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (rng.randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector3i
	start_pos.x = rng.randi() % (border_size - width + 1)
	start_pos.z = rng.randi() % (border_size - height + 1)
	
	#check for overlapping:
	for r in range(-room_margin, height+room_margin):
		for c in range(-room_margin,width+room_margin):
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			if grid_map.get_cell_item(pos) == 0:
				make_room(rec-1)
				return
	
	#For saving rooms for further use
	var room : PackedVector3Array = []
	
	#Draws the room
	for r in height:
		for c in width:
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			grid_map.set_cell_item(pos,0)
			room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width)/2)
	var avg_z : float = start_pos.z + (float(height)/2)
	var pos : Vector3 = Vector3(avg_x,0,avg_z)
	room_positions.append(pos)

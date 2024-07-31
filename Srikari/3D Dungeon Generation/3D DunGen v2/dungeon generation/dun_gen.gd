extends Node3D

@onready var grid_map : GridMap = $GridMap
@onready var ui_scene : PackedScene = preload("res://UI.tscn")
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

@export var start : bool = false : set = set_start

var my_timer : Timer

func _ready():
	add_child(ui_instance)
	start_button.connect("pressed", _on_start_button_pressed)
	my_timer = Timer.new()
	add_child(my_timer)
	my_timer.wait_time = 0.1  # Set the desired wait time
	my_timer.one_shot = true
	my_timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	# Code to execute when the timer times out
	print("Timer timed out!")

func _on_start_button_pressed():
	survival_chance = survival_chance_input.value
	border_size = int(border_size_input.value)
	room_number = int(room_number_input.value)
	room_margin = int(room_margin_input.value)
	room_recursion = int(room_recursion_input.value)
	min_room_size = int(min_room_size_input.value)
	max_room_size = int(max_room_size_input.value)
	custom_seed = custom_seed_input.text
	start = true

func set_start(val: bool):
	start = val
	if start:
		generate()

@export_range(0, 1) var survival_chance : float = 0.25
@export var border_size : int = 20 : set = set_border_size

func set_border_size(val: int) -> void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()

@export var room_number : int = 4
@export var room_margin : int = 1
@export var room_recursion : int = 15
@export var min_room_size : int = 2
@export var max_room_size : int = 4
@export_multiline var custom_seed : String = "" : set = set_seed

func set_seed(val: String) -> void:
	custom_seed = val
	seed(val.hash())

var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []

func visualize_border():
	grid_map.clear()
	for i in range(-1, border_size + 1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)

func generate():
	room_tiles.clear()
	room_positions.clear()
	var t : int = 0
	if custom_seed:
		set_seed(custom_seed)
	visualize_border()
	for i in range(room_number):
		t += 1
		make_room(room_recursion)
		if t % 17 == 16:
			my_timer.start()
			await my_timer.timeout

	var rpv2 : PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()

	for p in room_positions:
		rpv2.append(Vector2(p.x, p.z))
		del_graph.add_point(del_graph.get_available_point_id(), Vector2(p.x, p.z))
		mst_graph.add_point(mst_graph.get_available_point_id(), Vector2(p.x, p.z))

	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(rpv2))

	for i in range(delaunay.size() / 3):
		var p1 : int = delaunay.pop_front()
		var p2 : int = delaunay.pop_front()
		var p3 : int = delaunay.pop_front()
		del_graph.connect_points(p1, p2)
		del_graph.connect_points(p2, p3)
		del_graph.connect_points(p1, p3)

	var visited_points : PackedInt32Array = []
	if room_positions.size() > 0:
		visited_points.append(randi() % room_positions.size())
	else:
		print("Error: No room positions available for pathfinding.")
		return
		
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con : PackedInt32Array = [vp, c]
					possible_connections.append(con)

		var connection : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) < rpv2[connection[0]].distance_squared_to(rpv2[connection[1]]):
				connection = pc

		visited_points.append(connection[1])
		mst_graph.connect_points(connection[0], connection[1])
		del_graph.disconnect_points(connection[0], connection[1])

	var hallway_graph : AStar2D = mst_graph

	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c > p:
				var kill : float = randf()
				if survival_chance > kill:
					hallway_graph.connect_points(p, c)

	create_hallways(hallway_graph)

	# Call the function from dun_mesh.gd to create the mesh layer
	if has_node("DunMesh"):  # Replace with your actual node path
		var mesh_node : Node3D = get_node("DunMesh")  # Replace with your actual node path
		mesh_node.call("create_dungeon")

func create_hallways(hallway_graph : AStar2D):
	var hallways : Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c > p:
				var room_from : PackedVector3Array = room_tiles[p]
				var room_to : PackedVector3Array = room_tiles[c]
				var tile_from : Vector3 = room_from[0]
				var tile_to : Vector3 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c]) < tile_from.distance_squared_to(room_positions[c]):
						tile_from = t
				for t in room_to:
					if t.distance_squared_to(room_positions[p]) < tile_to.distance_squared_to(room_positions[p]):
						tile_to = t
				var hallway : PackedVector3Array = [tile_from, tile_to]
				hallways.append(hallway)
				grid_map.set_cell_item(tile_from, 2)
				grid_map.set_cell_item(tile_to, 2)

	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * border_size
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	for t in grid_map.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x, t.z))
	var _t : int = 0
	for h in hallways:
		_t += 1
		var pos_from : Vector2i = Vector2i(h[0].x, h[0].z)
		var pos_to : Vector2i = Vector2i(h[1].x, h[1].z)
		var hall : PackedVector2Array = astar.get_point_path(pos_from, pos_to)

		for t in hall:
			var pos : Vector3i = Vector3i(t.x, 0, t.y)
			if grid_map.get_cell_item(pos) < 0:
				grid_map.set_cell_item(pos, 1)
		if _t % 16 == 15:
			await get_tree().create_timer(0.1).timeout

func make_room(rec : int):
	if rec <= 0:
		return

	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var x : int = (randi() % (border_size - width)) + 1
	var z : int = (randi() % (border_size - height)) + 1

	var room : PackedVector3Array = []
	for i in range(width):
		for j in range(height):
			room.append(Vector3(x + i, 0, z + j))

	if not intersecting(room):
		room_tiles.append(room)
		room_positions.append(Vector3(x + width / 2, 0, z + height / 2))
		for t in room:
			grid_map.set_cell_item(t, 0)
		if randi() % 2 == 0:
			make_room(rec - 1)
			make_room(rec - 1)

func intersecting(room : PackedVector3Array) -> bool:
	var room_min : Vector3 = room[0]
	var room_max : Vector3 = room[0]

	# Calculate the bounding box of the new room
	for t in room:
		room_min = Vector3(min(room_min.x, t.x), min(room_min.y, t.y), min(room_min.z, t.z))
		room_max = Vector3(max(room_max.x, t.x), max(room_max.y, t.y), max(room_max.z, t.z))

	# Check against existing rooms
	for r in room_tiles:
		var existing_min : Vector3 = r[0]
		var existing_max : Vector3 = r[0]

		# Calculate the bounding box of the existing room
		for t in r:
			existing_min = Vector3(min(existing_min.x, t.x), min(existing_min.y, t.y), min(existing_min.z, t.z))
			existing_max = Vector3(max(existing_max.x, t.x), max(existing_max.y, t.y), max(existing_max.z, t.z))

		# Check if the bounding boxes intersect
		if (room_min.x <= existing_max.x and room_max.x >= existing_min.x and
			room_min.y <= existing_max.y and room_max.y >= existing_min.y and
			room_min.z <= existing_max.z and room_max.z >= existing_min.z):
			return true

	return false

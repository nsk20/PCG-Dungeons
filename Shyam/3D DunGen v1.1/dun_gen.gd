@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var start : bool = false : set = set_start
func set_start(val:bool)->void:
	start = val
	if start:
		seed_value = rng.randi()  # Generate a new random seed
	generate()




@export_range(0,1) var survival_chance : float = 0.25
@export var border_size : int = 20 : set = set_border_size
func set_border_size(val :  int) -> void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()
	

@export var room_number : int = 4
@export var room_margin : int = 1
@export var room_recursion : int = 15
@export var min_room_size : int = 2
@export var max_room_size : int = 4
@export var seed_value: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []
var start_room_index: int = -1
var end_room_index: int = -1
var key_room_index: int = -1

func designate_special_rooms():
	if room_tiles.size() < 3:
		print("Not enough rooms for special designations")
		return
	
	# Designate start room (preferably one with fewer connections)
	start_room_index = rng.randi() % room_tiles.size()
	
	# Designate end room (preferably far from start)
	var max_distance = 0
	for i in range(room_tiles.size()):
		if i != start_room_index:
			var distance = room_positions[i].distance_to(room_positions[start_room_index])
			if distance > max_distance:
				max_distance = distance
				end_room_index = i
	
	# Designate key room (not start or end)
	var available_rooms = range(room_tiles.size())
	available_rooms.erase(start_room_index)
	available_rooms.erase(end_room_index)
	key_room_index = available_rooms[rng.randi() % available_rooms.size()]

func set_manual_seed(new_seed: int):
	seed_value = new_seed
	generate()

func setup_seed():
	if seed_value == 0:
		seed_value = rng.randi()  # Generate a random seed if none is provided
	rng.seed = seed_value
	print("Using seed: ", seed_value)  # This helps with debugging and reproducing layouts

func visualize_special_rooms():
	if start_room_index >= 0:
		for tile in room_tiles[start_room_index]:
			grid_map.set_cell_item(tile, 4)  # Assuming 4 is a new mesh for start room
	
	if end_room_index >= 0:
		for tile in room_tiles[end_room_index]:
			grid_map.set_cell_item(tile, 5)  # Assuming 5 is a new mesh for end room
	
	if key_room_index >= 0:
		var key_room = room_tiles[key_room_index]
		var key_position = key_room[rng.randi() % key_room.size()]  # Choose a random tile in the room
		grid_map.set_cell_item(key_position, 6)  # Assuming 6 is a new mesh for key

func visualize_border():
	grid_map.clear()
	for i in range (-1,border_size+1):
		grid_map.set_cell_item(Vector3i(i,0,-1), 3)
		grid_map.set_cell_item(Vector3i(i,0,border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size,0,i), 3)
		grid_map.set_cell_item(Vector3i(-1,0,i), 3)
		

func generate():
	setup_seed()
	room_tiles.clear()
	room_positions.clear()
	visualize_border()
	for i in room_number:
		make_room(room_recursion)
	print(room_positions)
	designate_special_rooms()
	
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
	visualize_special_rooms()


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


func make_room(rec:int):
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
	
	pass

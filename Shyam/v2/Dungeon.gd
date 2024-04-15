extends Node2D

@export var width: int = 50
@export var height: int = 50
@export var initialFillPercent: int = 45
@export var smoothnessIterations: int = 5

var map: Array
var rooms: Array = []

func _ready():
	generate_map()

func generate_map():
	map = []
	random_fill_map()
	for i in range(smoothnessIterations):
		smooth_map()

	identify_rooms()
	for i in range(smoothnessIterations):
		smooth_map()

func random_fill_map():
	for x in range(width):
		map.append([])
		for y in range(height):
			if randi_range(0, 99) < initialFillPercent:
				map[x].append(1)
			else:
				map[x].append(0)

func smooth_map():
	var newMap = []
	for x in range(width):
		newMap.append([])
		for y in range(height):
			var neighbourWallTiles = get_surrounding_wall_count(x, y)
			if neighbourWallTiles > 4:
				newMap[x].append(1)
			elif neighbourWallTiles < 4:
				newMap[x].append(0)
			else:
				newMap[x].append(map[x][y])
	map = newMap

func get_surrounding_wall_count(gridX, gridY):
	var wallCount = 0
	for neighbourX in range(gridX - 1, gridX + 2):
		for neighbourY in range(gridY - 1, gridY + 2):
			if neighbourX >= 0 and neighbourX < width and neighbourY >= 0 and neighbourY < height:
				if neighbourX != gridX or neighbourY != gridY:
					wallCount += map[neighbourX][neighbourY]
			else:
				wallCount += 1
	return wallCount

func identify_rooms():
	rooms.clear()
	var visited = _init_visited_array()
	for x in range(width):
		for y in range(height):
			if visited[x][y] or map[x][y] == 1:
				continue
			var newRoom = flood_fill(x, y, visited)
			if newRoom.size() > 0:
				rooms.append(newRoom)

func flood_fill(x: int, y: int, visited):
	var tiles = []
	var stack = [[x, y]]
	while stack.size() > 0:
		var tile = stack.pop_back()
		var cx = tile[0]
		var cy = tile[1]
		if visited[cx][cy]:
			continue
		visited[cx][cy] = true
		if map[cx][cy] == 1:
			continue
		tiles.append(Vector2(cx, cy))
		for nx in range(cx - 1, cx + 2):
			for ny in range(cy - 1, cy + 2):
				if nx >= 0 and nx < width and ny >= 0 and ny < height and not visited[nx][ny]:
					stack.append([nx, ny])
	return tiles

func _init_visited_array() -> Array:
	var visited = []
	for x in range(width):
		var row = []
		for y in range(height):
			row.append(false)  # Every cell starts as not visited
		visited.append(row)
	return visited

func _draw():
	if map != null:
		for x in range(width):
			for y in range(height):
				var color = Color.WHITE  # Default to white for open spaces
				if map[x][y] == 1:       # Change to black if it's a wall
					color = Color.BLACK
				var pos = Vector2(x, y)  # Calculate the position
				draw_rect(Rect2(pos * 10, Vector2(10, 10)), color)  # Draw the rectangle

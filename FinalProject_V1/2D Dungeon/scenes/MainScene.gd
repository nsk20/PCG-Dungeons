extends Control

var is_drawing = false
var start_pos = Vector2()
var stairs_tool_active = false
var polygon_tool_active = false
var path_tool_active = false
var rectangle_tool_active = false
var wall_tool_active = false
var door_tool_active = false
var bridge_tool_active = false
var polygon_sides = 6
var path_points = []

var log_textedit: TextEdit

# Variables for selection
var is_selecting = false
var selection_start = Vector2()
var selection_end = Vector2()

# Load the Stairs, Polygon, Path, Rectangle, Wall, Door, and Bridge scenes
var StairsScene: PackedScene
var PolygonScene: PackedScene
var PathScene: PackedScene
var RectangleScene: PackedScene
var WallScene: PackedScene
var DoorScene: PackedScene
var BridgeScene: PackedScene

# Mouse pointer sprite
var mouse_pointer: Sprite2D
var sprite_offset = Vector2(-10, -10)

# List to hold selected objects
var selected_objects = []

# Keyboard shortcut for deletion
const DELETE_KEY = KEY_DELETE

func _ready():
	# Load scenes
	StairsScene = load("res://2D Dungeon/scenes/Stairs.tscn")
	PolygonScene = load("res://2D Dungeon/scenes/Polygon.tscn")
	PathScene = load("res://2D Dungeon/scenes/Path.tscn")
	RectangleScene = load("res://2D Dungeon/scenes/Rectangle.tscn")
	WallScene = load("res://2D Dungeon/scenes/Wall.tscn")
	DoorScene = load("res://2D Dungeon/scenes/Door.tscn")
	BridgeScene = load("res://2D Dungeon/scenes/Bridge.tscn")
	
	log_textedit = $LogTextEdit

	# Connect buttons
	$Panel/StairToolButton.connect("pressed", _on_StairToolButton_pressed)
	$Panel/PolygonToolButton.connect("pressed", _on_PolygonToolButton_pressed)
	$Panel/PathToolButton.connect("pressed", _on_PathToolButton_pressed)
	$Panel/RectangleToolButton.connect("pressed", _on_RectangleToolButton_pressed)
	$Panel/WallToolButton.connect("pressed", _on_WallToolButton_pressed)
	$Panel/DoorToolButton.connect("pressed", _on_DoorToolButton_pressed)
	$Panel/BridgeToolButton.connect("pressed", _on_BridgeToolButton_pressed)

	# Create and add the mouse pointer sprite
	mouse_pointer = Sprite2D.new()
	mouse_pointer.texture = preload("res://2D Dungeon/assets/Point2.png")
	add_child(mouse_pointer)

func _on_StairToolButton_pressed():
	stairs_tool_active = true
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	bridge_tool_active = false
	print("Stairs Tool Activated")
	append_to_log("Stairs Tool Activated")

func _on_PolygonToolButton_pressed():
	polygon_tool_active = true
	stairs_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	bridge_tool_active = false
	print("Polygon Tool Activated")
	append_to_log("Polygon Tool Activated")

func _on_PathToolButton_pressed():
	path_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	bridge_tool_active = false
	path_points.clear()
	print("Path Tool Activated")
	append_to_log("Path Tool Activated")

func _on_RectangleToolButton_pressed():
	rectangle_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	bridge_tool_active = false
	print("Rectangle Tool Activated")
	append_to_log("Rectangle Tool Activated")

func _on_WallToolButton_pressed():
	wall_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	door_tool_active = false
	bridge_tool_active = false
	print("Wall Tool Activated")
	append_to_log("Wall Tool Activated")

func _on_DoorToolButton_pressed():
	door_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	bridge_tool_active = false
	print("Door Tool Activated")
	append_to_log("Door Tool Activated")

func _on_BridgeToolButton_pressed():
	bridge_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	print("Bridge Tool Activated")
	append_to_log("Bridge Tool Activated")

func _input(event):
	# Update the mouse pointer position
	if event is InputEventMouseMotion:
		mouse_pointer.position = event.position + sprite_offset

	if stairs_tool_active:
		handle_stairs_input(event)
	elif polygon_tool_active:
		handle_polygon_input(event)
	elif path_tool_active:
		handle_path_input(event)
	elif rectangle_tool_active:
		handle_rectangle_input(event)
	elif wall_tool_active:
		handle_wall_input(event)
	elif door_tool_active:
		handle_door_input(event)
	elif bridge_tool_active:
		handle_bridge_input(event)
		
	

func handle_stairs_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Drawing started at ", start_pos)
					append_to_log("Drawing started at " + str(start_pos))
				else:
					is_drawing = false
					stairs_tool_active = false
					draw_stairs(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					stairs_tool_active = false
					draw_stairs(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))

func handle_polygon_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Polygon center at ", start_pos)
					append_to_log("Polygon center at " + str(start_pos))
				else:
					is_drawing = false
					polygon_tool_active = false
					create_polygon(start_pos, event.position.distance_to(start_pos))
					print("Polygon radius set to ", event.position.distance_to(start_pos))
					append_to_log("Polygon radius set to " + str(event.position.distance_to(start_pos)))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					polygon_tool_active = false
					create_polygon(start_pos, event.position.distance_to(start_pos))
					print("Polygon radius set to ", event.position.distance_to(start_pos))
					append_to_log("Polygon radius set to " + str(event.position.distance_to(start_pos)))

func handle_path_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Input.is_key_pressed(KEY_CTRL):  # Check if Control key is pressed
				if path_points.size() > 1:
					draw_path(path_points)
				path_tool_active = false
				path_points.clear()
				print("Path drawing ended")
			else:
				path_points.append(event.position)
				print("Path point added at ", event.position)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if path_points.size() > 1:
				draw_path(path_points)
			path_tool_active = false
			path_points.clear()
			print("Path drawing ended")

func handle_rectangle_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Drawing started at ", start_pos)
					append_to_log("Drawing started at " + str(start_pos))
				else:
					is_drawing = false
					rectangle_tool_active = false
					draw_rectangle(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					rectangle_tool_active = false
					draw_rectangle(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))

func handle_wall_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Drawing started at ", start_pos)
					append_to_log("Drawing started at " + str(start_pos))
				else:
					is_drawing = false
					wall_tool_active = false
					draw_wall(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					wall_tool_active = false
					draw_wall(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))

func handle_door_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Drawing started at ", start_pos)
					append_to_log("Drawing started at " + str(start_pos))
				else:
					is_drawing = false
					door_tool_active = false
					draw_door(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					door_tool_active = false
					draw_door(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))

func handle_bridge_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_drawing:
					is_drawing = true
					start_pos = event.position
					print("Drawing started at ", start_pos)
					append_to_log("Drawing started at " + str(start_pos))
				else:
					is_drawing = false
					bridge_tool_active = false
					draw_bridge(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					bridge_tool_active = false
					draw_bridge(start_pos, event.position)
					print("Drawing ended at ", event.position)
					append_to_log("Drawing ended at " + str(event.position))

func draw_stairs(start, end):
	if StairsScene == null:
		print("Error: StairsScene is null.")
		return

	var stairs = StairsScene.instantiate()
	if stairs == null:
		print("Error: Stairs instance could not be created.")
		return

	stairs.start_position = start
	stairs.end_position = end
	add_child(stairs)
	stairs.update()  # Ensure the stairs node is updated if needed
	print("Stairs added to the scene.")


func create_polygon(center: Vector2, radius: float):
	if PolygonScene == null:
		print("Error: PolygonScene is null.")
		return

	var polygon = PolygonScene.instantiate()
	if polygon == null:
		print("Error: Polygon instance could not be created.")
		return

	polygon.center = center
	polygon.radius = radius
	polygon.sides = 6  # or however many sides you want
	add_child(polygon)
	print("Polygon added to the scene.")


func draw_path(points):
	if PathScene == null:
		print("Error: PathScene is null.")
		return

	var path = PathScene.instantiate()
	if path == null:
		print("Error: Path instance could not be created.")
		return

	path.set("points", points)
	add_child(path)
	path.call("draw_path")
	print("Path added to the scene.")

func draw_rectangle(start, end):
	if RectangleScene == null:
		print("Error: RectangleScene is null.")
		return

	var rect = RectangleScene.instantiate()
	if rect == null:
		print("Error: Rectangle instance could not be created.")
		return
		
	rect.set("start_position", start)
	rect.set("end_position", end)
	add_child(rect)
	rect.draw_rectangle()  # Ensure this matches the method signature in Rectangle.gd
	print("Rectangle added to the scene.")

func draw_wall(start, end):
	if WallScene == null:
		print("Error: WallScene is null.")
		return

	var wall = WallScene.instantiate()
	if wall == null:
		print("Error: Wall instance could not be created.")
		return

	wall.set("start_position", start)
	wall.set("end_position", end)
	add_child(wall)
	wall.call("draw_wall")
	print("Wall added to the scene.")

func draw_door(start, end):
	if DoorScene == null:
		print("Error: DoorScene is null.")
		return

	var door = DoorScene.instantiate()
	if door == null:
		print("Error: Door instance could not be created.")
		return

	door.set("start_position", start)
	door.set("end_position", end)
	add_child(door)
	door.call("draw_door")
	print("Door added to the scene.")

func draw_bridge(start, end):
	if BridgeScene == null:
		print("Error: BridgeScene is null.")
		return

	var bridge = BridgeScene.instantiate()
	if bridge == null:
		print("Error: Bridge instance could not be created.")
		return

	bridge.set("start_position", start)
	bridge.set("end_position", end)
	add_child(bridge)
	bridge.call("draw_bridge", start, end)
	print("Bridge added to the scene.")
	
	
	# Function to append log messages to the TextEdit
func append_to_log(message: String):
	if log_textedit != null:
		#if log_textedit.get_text().is_empty():
			#log_textedit.set_text(message)
		if log_textedit.text == "":
			log_textedit.text = message
		else:
			#log_textedit.append_bbcode("\n" + message)
			log_textedit.text += "\n" + message
	else:
		print("Error: log_textedit is not initialized.")

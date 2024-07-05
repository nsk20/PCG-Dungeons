extends Control

var is_drawing = false
var start_pos = Vector2()
var stairs_tool_active = false
var polygon_tool_active = false
var path_tool_active = false
var rectangle_tool_active = false  # Variable for rectangle tool
var wall_tool_active = false  # Variable for wall tool
var door_tool_active = false  # New variable for door tool
var selection_tool_active = false  # Variable for selection tool
var polygon_sides = 6  # Number of sides for the polygon
var path_points = []

var log_textedit: TextEdit

# Variables for selection
var is_selecting = false
var selection_start = Vector2()
var selection_end = Vector2()

# Load the Stairs, Polygon, Path, Rectangle, Wall, and Door scenes
var StairsScene: PackedScene
var PolygonScene: PackedScene
var PathScene: PackedScene
var RectangleScene: PackedScene  # Variable for rectangle scene
var WallScene: PackedScene  # Variable for wall scene
var DoorScene: PackedScene  # New variable for door scene

# Mouse pointer sprite
var mouse_pointer: Sprite2D
var sprite_offset = Vector2(-20, -20)  # Adjust the offset to position the sprite closer to the mouse pointer

# List to hold selected objects
var selected_objects = []

# Keyboard shortcut for deletion
const DELETE_KEY = KEY_DELETE

func _ready():
	StairsScene = load("res://scenes/Stairs.tscn")
	PolygonScene = load("res://scenes/Polygon.tscn")
	PathScene = load("res://scenes/Path.tscn")
	RectangleScene = load("res://scenes/Rectangle.tscn")
	WallScene = load("res://scenes/Wall.tscn")
	DoorScene = load("res://scenes/Door.tscn")  # Load your Door scene
	log_textedit = $LogTextEdit

	if StairsScene == null:
		print("Error: Stairs scene could not be loaded.")
	else:
		print("Stairs scene loaded successfully.")

	if PolygonScene == null:
		print("Error: Polygon scene could not be loaded.")
	else:
		print("Polygon scene loaded successfully.")

	if PathScene == null:
		print("Error: Path scene could not be loaded.")
	else:
		print("Path scene loaded successfully.")

	if RectangleScene == null:
		print("Error: Rectangle scene could not be loaded.")
	else:
		print("Rectangle scene loaded successfully.")

	if WallScene == null:
		print("Error: Wall scene could not be loaded.")
	else:
		print("Wall scene loaded successfully.")

	if DoorScene == null:
		print("Error: Door scene could not be loaded.")
	else:
		print("Door scene loaded successfully.")

	$Panel/StairToolButton.connect("pressed", _on_StairToolButton_pressed)
	$Panel/PolygonToolButton.connect("pressed", _on_PolygonToolButton_pressed)
	$Panel/PathToolButton.connect("pressed", _on_PathToolButton_pressed)
	$Panel/RectangleToolButton.connect("pressed", _on_RectangleToolButton_pressed)  # Connect Rectangle Tool Button
	$Panel/WallToolButton.connect("pressed", _on_WallToolButton_pressed)  # Connect Wall Tool Button
	$Panel/DoorToolButton.connect("pressed", _on_DoorToolButton_pressed)  # Connect Door Tool Button
	$Panel/SelectToolButton.connect("pressed", _on_SelectToolButton_pressed)  # Connect Select Tool Button

	# Create and add the mouse pointer sprite
	mouse_pointer = Sprite2D.new()
	mouse_pointer.texture = preload("res://assets/Point2.png") 
	add_child(mouse_pointer)

func _on_StairToolButton_pressed():
	stairs_tool_active = true
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	selection_tool_active = false
	print("Stairs Tool Activated")
	append_to_log("Stairs Tool Activated")

func _on_PolygonToolButton_pressed():
	polygon_tool_active = true
	stairs_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	selection_tool_active = false
	print("Polygon Tool Activated")
	append_to_log("Polygon Tool Activated")

func _on_PathToolButton_pressed():
	path_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	selection_tool_active = false
	path_points.clear()  # Clear previous path points
	print("Path Tool Activated")
	append_to_log("Path Tool Activated")

func _on_RectangleToolButton_pressed():
	rectangle_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	selection_tool_active = false
	print("Rectangle Tool Activated")
	append_to_log("Rectangle Tool Activated")

func _on_WallToolButton_pressed():
	wall_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	door_tool_active = false
	selection_tool_active = false
	print("Wall Tool Activated")
	append_to_log("Wall Tool Activated")

func _on_DoorToolButton_pressed():
	door_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	selection_tool_active = false
	print("Door Tool Activated")
	append_to_log("Door Tool Activated")

func _on_SelectToolButton_pressed():
	selection_tool_active = true
	stairs_tool_active = false
	polygon_tool_active = false
	path_tool_active = false
	rectangle_tool_active = false
	wall_tool_active = false
	door_tool_active = false
	print("Selection Tool Activated")
	append_to_log("Selection Tool Activated")

func _input(event):
	# Update the mouse pointer position
	if event is InputEventMouseMotion:
		mouse_pointer.position = event.position + sprite_offset

	# Check if any drawing tool is active
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
	elif selection_tool_active:
		handle_selection_input(event)

	# Handle deletion with DELETE key
	#if event is InputEventKey and event.pressed and event.scancode == DELETE_KEY:
	#	delete_selected_objects()

# Function to handle selection input
func handle_selection_input(event):
	if event is InputEventMouseButton:
		# Left-click to start selecting
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_selecting = true
				selection_start = event.position
			else:
				# Left-click released, end selection
				is_selecting = false
				selection_end = event.position
				select_objects()
		# Right-click to cancel selection
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			is_selecting = false

# Function to select objects within the selection area
func select_objects():
	# Clear previously selected objects
	selected_objects.clear()

	# Create a Rect2 for the selection area
	var selection_rect = Rect2(selection_start, selection_end - selection_start)
	if selection_rect.size.x < 0:
		selection_rect.position.x += selection_rect.size.x
		selection_rect.size.x = -selection_rect.size.x
	if selection_rect.size.y < 0:
		selection_rect.position.y += selection_rect.size.y
		selection_rect.size.y = -selection_rect.size.y

	# Iterate through all objects in the scene
	for child in get_tree().get_root().get_children():
		# Check if the object's bounding box intersects with the selection area
		if child is Node2D and child.has_method("get_global_rect") and selection_rect.intersects(child.get_global_rect()):
			# Add the object to the list of selected objects
			selected_objects.append(child)

# Function to delete selected objects
func delete_selected_objects():
	# Iterate through selected objects and remove them from the scene
	for obj in selected_objects:
		obj.queue_free()

	# Clear the list of selected objects
	selected_objects.clear()

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
					draw_regular_polygon(start_pos, event.position.distance_to(start_pos))
					print("Polygon radius set to ", event.position.distance_to(start_pos))
					append_to_log("Polygon radius set to" +str(event.position.distance_to(start_pos)))
			elif not event.pressed:
				if is_drawing:
					is_drawing = false
					polygon_tool_active = false
					draw_regular_polygon(start_pos, event.position.distance_to(start_pos))
					print("Polygon radius set to ", event.position.distance_to(start_pos))
					append_to_log("Polygon radius set to" +str(event.position.distance_to(start_pos)))

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

func draw_stairs(start, end):
	if StairsScene == null:
		print("Error: StairsScene is null.")
		return

	var stairs = StairsScene.instantiate()
	if stairs == null:
		print("Error: Stairs instance could not be created.")
		return

	stairs.set("start_position", start)
	stairs.set("end_position", end)
	add_child(stairs)
	stairs.call("draw")
	print("Stairs added to the scene.")

func draw_regular_polygon(center, radius):
	if PolygonScene == null:
		print("Error: PolygonScene is null.")
		return

	var polygon = PolygonScene.instantiate()
	if polygon == null:
		print("Error: Polygon instance could not be created.")
		return

	polygon.set("center", center)
	polygon.set("radius", radius)
	polygon.set("sides", polygon_sides)
	add_child(polygon)
	polygon.call("draw_regular_polygon")
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
	rect.call("draw_rectangle")
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

# Function to draw the door
func draw_door(start, end):
	if DoorScene == null:
		print("Error: DoorScene is null.")
		return
	
	var door = DoorScene.instantiate()
	if door == null:
		print("Error: Door instance could not be created.")
		return

	# Set door properties
	door.start_position = start
	door.end_position = end

	# Add the door to the scene
	add_child(door)

	# Call the draw_door function in the Door scene
	door.draw_door()
	print("Door added to the scene.")
	
	
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






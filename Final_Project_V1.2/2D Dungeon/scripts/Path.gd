extends Node2D

# Define the variables for the path
var points = []
var is_dragging = false
var dragging_point_index = -1
var point_radius = 8  # Radius for draggable points
var path_color = Color(0.7, 0.7, 0.7)  # Color for the path lines
var point_color = Color(1, 0, 0)  # Red points for dragging

func _ready():
	queue_redraw()  # Request a redraw to display the path

func _draw():
	# Draw the path
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], path_color, 2)
	
	# Draw draggable points
	for point in points:
		draw_point(point)

func draw_point(position: Vector2):
	draw_circle(position, point_radius, point_color)

func _input(event):
	var mouse_pos = get_local_mouse_position()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if we're clicking near an existing point to drag
				for i in range(points.size()):
					if (mouse_pos - points[i]).length() < point_radius:
						is_dragging = true
						dragging_point_index = i
						break
				
				# If not dragging an existing point, create a new point
				if not is_dragging:
					points.append(mouse_pos)
					print("Path point added at ", mouse_pos)
					queue_redraw()
			else:
				is_dragging = false
				dragging_point_index = -1
				queue_redraw()

	elif event is InputEventMouseMotion and is_dragging:
		if dragging_point_index != -1:
			points[dragging_point_index] = mouse_pos
			queue_redraw()

	elif event is InputEventKey:
		# Allow clearing points with a key press, e.g., 'C' key
		if event.is_action_pressed("ui_cancel"):
			points.clear()
			queue_redraw()

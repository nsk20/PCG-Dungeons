extends Node2D

var start_position = Vector2(0, 0)
var end_position = Vector2(100, 100)
var draw_color = Color(0.7, 0.7, 0.7)  # Default color
var point_radius = 8  # Radius for the draggable points
var point_color = Color(1, 0, 0)  # Color for the points

var is_dragging = false
var dragging_point = null
var is_deleted = false  # New variable to track deletion state

func _draw():
	if not is_deleted:  # Only draw if the rectangle has not been deleted
		var rect = Rect2(start_position, end_position - start_position)
		draw_rect(rect, draw_color, false, 10)  # Use the specified draw color for the border
		# Draw the draggable points at each corner
		draw_point(start_position)
		draw_point(end_position)
		draw_point(Vector2(start_position.x, end_position.y))
		draw_point(Vector2(end_position.x, start_position.y))

func draw_point(position: Vector2):
	draw_circle(position, point_radius, point_color)

func _ready():
	update()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_local_mouse_position()
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_deleted:
					if (mouse_pos - start_position).length() < point_radius:
						is_dragging = true
						dragging_point = 'start'
					elif (mouse_pos - end_position).length() < point_radius:
						is_dragging = true
						dragging_point = 'end'
					elif (mouse_pos - Vector2(start_position.x, end_position.y)).length() < point_radius:
						is_dragging = true
						dragging_point = 'bottom_left'
					elif (mouse_pos - Vector2(end_position.x, start_position.y)).length() < point_radius:
						is_dragging = true
						dragging_point = 'top_right'
			else:
				is_dragging = false
				dragging_point = null
	
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if not is_deleted:
					if (mouse_pos - start_position).length() < point_radius or \
					   (mouse_pos - end_position).length() < point_radius or \
					   (mouse_pos - Vector2(start_position.x, end_position.y)).length() < point_radius or \
					   (mouse_pos - Vector2(end_position.x, start_position.y)).length() < point_radius:
						delete_rectangle()

	elif event is InputEventMouseMotion and is_dragging:
		var mouse_pos = get_local_mouse_position()
		if dragging_point == 'start':
			start_position = mouse_pos
		elif dragging_point == 'end':
			end_position = mouse_pos
		elif dragging_point == 'bottom_left':
			start_position.x = mouse_pos.x
			end_position.y = mouse_pos.y
		elif dragging_point == 'top_right':
			start_position.y = mouse_pos.y
			end_position.x = mouse_pos.x
		update()

func update():
	queue_redraw()

func draw_rectangle():
	update()
	print("Rectangle drawn from ", start_position, " to ", end_position)

func delete_rectangle():
	is_deleted = true  # Set the deletion flag to true
	update()  # Request redraw to clear any remaining drawing
	print("Rectangle deleted")

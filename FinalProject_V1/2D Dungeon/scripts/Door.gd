extends Node2D

# Define the variables for the door
var start_position = Vector2(50, 50)
var end_position = Vector2(150, 250)
var door_color = Color(0.7, 0.7, 0.7)  # Example color, replace with your desired color
var point_radius = 8  # Radius for draggable points
var is_dragging = false
var dragging_point = null

func _ready():
	queue_redraw()

func _draw():
	draw_door()
	print("Drawing door")

func draw_door():
	if start_position == end_position:
		return  # Do not draw if start and end positions are the same

	var rect_pos = start_position
	var rect_size = end_position - start_position
	
	# Ensure the rectangle size is positive for drawing
	rect_size = Vector2(abs(rect_size.x), abs(rect_size.y))
	if rect_size == Vector2():
		return  # Do not draw if the size is zero

	# Draw the vertical rectangle
	draw_line(rect_pos, rect_pos + Vector2(rect_size.x, 0), door_color, 7)  # Top border
	draw_line(rect_pos, rect_pos + Vector2(0, rect_size.y), door_color, 7)  # Left border
	draw_line(rect_pos + Vector2(0, rect_size.y), rect_pos + Vector2(rect_size.x, rect_size.y), door_color, 7)  # Bottom border
	draw_line(rect_pos + Vector2(rect_size.x, 0), rect_pos + Vector2(rect_size.x, rect_size.y), door_color, 7)  # Right border

	# Draw lines extending from the top and bottom of the door
	var top_line_start = rect_pos + Vector2(rect_size.x / 2, 0)
	var top_line_end = top_line_start + Vector2(0, -20)  # Length of the top line
	draw_line(top_line_start, top_line_end, door_color, 7)

	var bottom_line_start = rect_pos + Vector2(rect_size.x / 2, rect_size.y)
	var bottom_line_end = bottom_line_start + Vector2(0, 20)  # Length of the bottom line
	draw_line(bottom_line_start, bottom_line_end, door_color, 7)

	# Draw draggable points
	draw_point(start_position)
	draw_point(end_position)

func draw_point(position: Vector2):
	draw_circle(position, point_radius, Color(1, 0, 0))  # Red points for dragging

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_local_mouse_position()
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if (mouse_pos - start_position).length() < point_radius:
					is_dragging = true
					dragging_point = 'start'
				elif (mouse_pos - end_position).length() < point_radius:
					is_dragging = true
					dragging_point = 'end'
			else:
				is_dragging = false
				dragging_point = null

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if (mouse_pos - start_position).length() < point_radius or (mouse_pos - end_position).length() < point_radius:
					delete_door()
	
	elif event is InputEventMouseMotion and is_dragging:
		var mouse_pos = get_local_mouse_position()
		if dragging_point == 'start':
			start_position = mouse_pos
		elif dragging_point == 'end':
			end_position = mouse_pos
		update()

func update():
	queue_redraw()

func draw_rectangle():
	queue_redraw()
	print("Rectangle drawn from ", start_position, " to ", end_position)

func delete_door():
	start_position = Vector2()
	end_position = Vector2()
	update()
	print("Door deleted")

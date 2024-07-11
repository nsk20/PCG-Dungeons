extends Node2D

var start_position = Vector2(-100, 0)
var end_position = Vector2(100, 200)
var step_height = 25
var point_radius = 8
var draw_color = Color(0.7, 0.7, 0.7)
var point_color = Color(1, 0, 0)  # Color for the points

var is_dragging = false
var dragging_point = null
var is_deleted = false  # New variable to track deletion state

func _draw():
	if is_deleted:
		return  # Skip drawing if the stairs are deleted
	
	var total_height = end_position.y - start_position.y
	var total_width = end_position.x - start_position.x
	var step_count = total_height / step_height
	
	for i in range(step_count):
		var current_height = start_position.y + (total_height / step_count) * i
		var step_start_x = start_position.x + (total_width / (step_count * 2)) * i
		var step_end_x = end_position.x - (total_width / (step_count * 2)) * i
		var step_start = Vector2(step_start_x, current_height)
		var step_end = Vector2(step_end_x, current_height)
		draw_line(step_start, step_end, draw_color, 10)
	
	# Draw the draggable points
	draw_point(start_position)
	draw_point(end_position)

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
			else:
				is_dragging = false
				dragging_point = null

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if not is_deleted:
					if (mouse_pos - start_position).length() < point_radius or \
					   (mouse_pos - end_position).length() < point_radius:
						delete_stairs()

	elif event is InputEventMouseMotion and is_dragging:
		var mouse_pos = get_local_mouse_position()
		if dragging_point == 'start':
			start_position = mouse_pos
		elif dragging_point == 'end':
			end_position = mouse_pos
		update()

func update():
	queue_redraw()

func delete_stairs():
	is_deleted = true  # Set the deletion flag to true
	queue_redraw()  # Request redraw to clear any remaining drawing
	print("Stairs deleted")

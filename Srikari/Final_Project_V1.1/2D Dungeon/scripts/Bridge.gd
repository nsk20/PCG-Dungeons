extends Node2D

var support_thickness = 10
var support_height = 100
var support_count = 8
var bridge_width = 500

var draw_color = Color(0.7, 0.7, 0.7)
var point_color = Color(1, 0, 0)  # Color for the points
var point_radius = 8

var start_point = Vector2(-bridge_width / 2, -support_height)
var end_point = Vector2(bridge_width / 2, 0)

var is_dragging = false
var dragging_point = null
var is_deleted = false  # New variable to track deletion state

func _draw():
	if is_deleted:
		return  # Skip drawing if the bridge is deleted
	
	# Draw the horizontal line at the top of the supports
	var start_top = start_point
	var end_top = Vector2(end_point.x, start_point.y)
	draw_line(start_top, end_top, draw_color, support_thickness)
	
	# Draw the vertical supports
	var support_spacing = bridge_width / (support_count + 1)
	for i in range(support_count):
		var x_pos = start_point.x + (i + 1) * support_spacing
		var start_support = Vector2(x_pos, start_point.y)
		var end_support = Vector2(x_pos, end_point.y)
		draw_line(start_support, end_support, draw_color, support_thickness)
	
	# Draw the horizontal line at the bottom of the supports
	var bottom_line_start = Vector2(start_point.x, end_point.y)
	var bottom_line_end = Vector2(end_point.x, end_point.y)
	draw_line(bottom_line_start, bottom_line_end, draw_color, support_thickness)

	# Draw the points
	draw_point(start_point)
	draw_point(end_point)

func draw_point(position: Vector2):
	draw_circle(position, point_radius, point_color)

func _ready():
	queue_redraw()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_local_mouse_position()  # Ensure this variable is declared here

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_deleted:
					if (mouse_pos - start_point).length() < point_radius:
						is_dragging = true
						dragging_point = 'start'
					elif (mouse_pos - end_point).length() < point_radius:
						is_dragging = true
						dragging_point = 'end'
			else:
				is_dragging = false
				dragging_point = null
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if not is_deleted:
					if (mouse_pos - start_point).length() < point_radius or \
					   (mouse_pos - end_point).length() < point_radius:
						delete_bridge()

	elif event is InputEventMouseMotion and is_dragging:
		var mouse_pos = get_local_mouse_position()  # Ensure this variable is declared here
		if dragging_point == 'start':
			start_point = mouse_pos
		elif dragging_point == 'end':
			end_point = mouse_pos
		update_bridge()

func update_bridge():
	bridge_width = (end_point - start_point).length()
	support_height = start_point.y - end_point.y
	queue_redraw()

func draw_bridge(start: Vector2, end: Vector2):
	# Update points based on the provided start and end positions
	start_point = start
	end_point = end
	update_bridge()

func delete_bridge():
	is_deleted = true  # Set the deletion flag to true
	queue_redraw()  # Request redraw to clear any remaining drawing
	print("Bridge deleted")

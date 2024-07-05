extends Node2D

var start_position = Vector2()
var end_position = Vector2()
var draw_color = Color(1, 1, 1)  # Default color

func _draw():
	var rect = Rect2(start_position, end_position - start_position)
	draw_rect(rect, draw_color, false, 20)  # Use the specified draw color

func draw_rectangle():
	queue_redraw()  # Schedule the node for redraw
	print("Rectangle drawn from ", start_position, " to ", end_position)

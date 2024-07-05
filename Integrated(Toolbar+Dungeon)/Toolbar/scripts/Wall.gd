extends Node2D

var start_position = Vector2()
var end_position = Vector2()
var wall_thickness = 20  # Default thickness for the wall
var draw_color = Color(0, 0, 0)  # Default color for the wall

func _draw():
	draw_line(start_position, end_position, draw_color, wall_thickness)  # Drawing the wall as a thick line

func draw_wall():
	queue_redraw()  # Schedule the node for redraw
	print("Wall drawn from ", start_position, " to ", end_position)

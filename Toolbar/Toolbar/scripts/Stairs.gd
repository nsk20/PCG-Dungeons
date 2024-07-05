extends Node2D

var start_position = Vector2()
var end_position = Vector2()

func _draw():
	#var step_count = 10  # Number of steps in the stairs
	var step_height = 25
	var total_height = end_position.y - start_position.y
	var total_width = end_position.x - start_position.x
	var step_count = total_height/step_height

	for i in range(step_count):
		var current_height = start_position.y + (total_height / step_count) * i
		var step_start_x = start_position.x + (total_width / (step_count * 2)) * i
		var step_end_x = end_position.x - (total_width / (step_count * 2)) * i
		var step_start = Vector2(step_start_x, current_height)
		var step_end = Vector2(step_end_x, current_height)
		draw_line(step_start, step_end, Color(1, 1, 1), 10)

func draw():
	queue_redraw()

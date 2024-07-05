extends Node2D

var points = []

func _draw():
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], Color(1, 1, 1), 2)  

func draw_path():
	queue_redraw()  # Schedule the node for redraw
	print("Path drawn with points: ", points)

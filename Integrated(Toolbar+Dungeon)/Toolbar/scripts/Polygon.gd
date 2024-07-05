extends Node2D

var center: Vector2
var radius: float
var sides: int

func _draw():
	if sides < 3:
		return

	var angle_step = TAU / sides
	var points = []

	for i in range(sides):
		var angle = angle_step * i
		var point = center + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	for i in range(sides):
		draw_line(points[i], points[(i + 1) % sides], Color(1, 1, 1), 20)

func draw_regular_polygon():
	queue_redraw()

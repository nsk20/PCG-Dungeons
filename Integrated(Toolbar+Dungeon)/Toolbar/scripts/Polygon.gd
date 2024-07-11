extends Node2D

var center: Vector2 = Vector2(0, 0)
var radius: float = 100.0
var sides: int = 6
var point_radius: float = 7
var draw_color: Color = Color(0.7, 0.7, 0.7)
var point_color: Color = Color(1, 0, 0)  # Color for the draggable points

var is_dragging: bool = false
var dragging_point: String = ""  # Initialize with an empty string
var is_deleted: bool = false  # New variable to track deletion state

func _draw():
	if is_deleted:
		return  # Skip drawing if the polygon is deleted

	if sides < 3:
		return

	var angle_step = TAU / sides
	var points = []

	# Calculate polygon vertices
	for i in range(sides):
		var angle = angle_step * i
		var point = center + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	# Draw the polygon
	for i in range(sides):
		draw_line(points[i], points[(i + 1) % sides], draw_color, 10)
	
	# Draw the draggable points
	draw_point(center)
	for point in points:
		draw_point(point)

func draw_point(position: Vector2):
	draw_circle(position, point_radius, point_color)

func _ready():
	queue_redraw()

func _input(event):
	if event is InputEventMouseButton:
		var local_mouse_pos = get_local_mouse_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not is_deleted:
					if (local_mouse_pos - center).length() < point_radius:
						is_dragging = true
						dragging_point = 'center'
					else:
						var angle_step = TAU / sides
						var vertices = []
						for i in range(sides):
							var angle = angle_step * i
							var point = center + Vector2(cos(angle), sin(angle)) * radius
							vertices.append(point)

						for i in range(sides):
							if (local_mouse_pos - vertices[i]).length() < point_radius:
								is_dragging = true
								dragging_point = 'vertex_' + str(i)
								break
			else:
				is_dragging = false
				dragging_point = ""
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if not is_deleted:
					if (local_mouse_pos - center).length() < point_radius:
						delete_polygon()
					else:
						var angle_step = TAU / sides
						var vertices = []
						for i in range(sides):
							var angle = angle_step * i
							var point = center + Vector2(cos(angle), sin(angle)) * radius
							vertices.append(point)

						for i in range(sides):
							if (local_mouse_pos - vertices[i]).length() < point_radius:
								delete_polygon()
								break
	
	elif event is InputEventMouseMotion and is_dragging:
		var local_mouse_position = get_local_mouse_position()
		if dragging_point == 'center':
			center = local_mouse_position
		elif dragging_point.begins_with('vertex_'):
			var vertex_index = int(dragging_point.split('_')[1])
			var angle_step = TAU / sides
			var angle = angle_step * vertex_index
			radius = (local_mouse_position - center).length()
		update()

func update():
	queue_redraw()

func delete_polygon():
	is_deleted = true  # Set the deletion flag to true
	update()  # Request redraw to clear any remaining drawing
	print("Polygon deleted")

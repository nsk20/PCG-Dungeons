extends Node2D

var is_selecting = false
var selection_start = Vector2()
var selection_end = Vector2()

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_selection(event.position)
			else:
				end_selection(event.position)

func start_selection(position):
	is_selecting = true
	selection_start = position

func end_selection(position):
	is_selecting = false
	selection_end = position
	process_selection()

func process_selection():
	var selected_objects = []

	# Determine objects within selection area
	var selection_rect = Rect2(selection_start, selection_end - selection_start)
	for node in get_tree().get_nodes_in_group("selectable"):
		if node is Node2D:
			if selection_rect.has_point(node.global_position):
				selected_objects.append(node)

	# Delete or modify selected objects
	for obj in selected_objects:
		obj.queue_free()

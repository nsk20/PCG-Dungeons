@tool
extends Node3D

@export var vertical_offset: float = 0.25

func _ready():
	apply_vertical_offset()

func apply_vertical_offset():
	for child in get_children():
		if child is MeshInstance3D:
			child.transform.origin.y += vertical_offset

func remove_wall_up():
	$wall_up.free()
func remove_wall_down():
	$wall_down.free()
func remove_wall_left():
	$wall_left.free()
func remove_wall_right():
	$wall_right.free()
func remove_door_up():
	$door_up.free()
func remove_door_down():
	$door_down.free()
func remove_door_left():
	$door_left.free()
func remove_door_right():
	$door_right.free()
	
func set_vertical_offset(new_offset: float):
	vertical_offset = new_offset
	apply_vertical_offset()

extends Node2D

var start_position = Vector2()
var end_position = Vector2()
var door_length = 100  # Example value, replace with your desired length
var door_thickness = 5  # Example value, replace with your desired thickness
var door_color = Color(0.8, 0.4, 0.2)  # Example color, replace with your desired color

func draw_door():
	var door_center = (start_position + end_position) / 2  # Calculate the center of the door

	# Draw the main rectangle part of the door
	draw_rect(Rect2(door_center - Vector2(door_length / 2, door_thickness / 2), Vector2(door_length, door_thickness)), door_color)

	# Draw lines at both ends of the rectangle
	draw_line(door_center - Vector2(door_length / 2, 0), door_center - Vector2(door_length / 2, door_thickness), door_color, door_thickness)
	draw_line(door_center + Vector2(door_length / 2, 0), door_center + Vector2(door_length / 2, door_thickness), door_color, door_thickness)

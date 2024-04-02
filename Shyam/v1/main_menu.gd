class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button

@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button

@export var start_level = preload("res://Dungeon.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_button_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_exit_pressed() -> void:
	get_tree().quit()
	

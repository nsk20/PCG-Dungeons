extends Control




var dun_gen = [
	preload("res://dungeon generation/dun_gen.tscn")
]

var names = {
	dun_gen: "Procedural Dungeon Generation",
}
# Called when the node enters the scene tree for the first time.
func _ready():
	for name in names.values():
		%OptionButton.add_item(name)
	%Seed.value = randi()
	


func _process(delta):
	pass
	


func _on_regenerate_button_pressed():
	pass # Replace with function body.

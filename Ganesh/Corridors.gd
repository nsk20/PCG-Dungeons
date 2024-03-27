class_name Corridors
extends Node

func add_corridor(target_corridor:DungeonCorridor):
	if target_corridor in get_children():
		return
	add_child(target_corridor)
func delete_corridor(target_corridor:DungeonCorridor):
	if target_corridor in get_children():
		target_corridor.queue_free()
func get_corridor(zone_a:DungeonZone,zone_b:DungeonZone):#Be advised, will not check for multiple corridors with same end points
	for i in get_children():
		if i.zone_a==zone_a and i.zone_b==zone_b:
			return i
	return null
func make_corridor(zone_a:DungeonZone,zone_b:DungeonZone):
	var new_corridor=DungeonCorridor.new()
	new_corridor.zone_a=zone_a
	new_corridor.zone_b=zone_b
	return new_corridor

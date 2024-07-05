class_name Corridors
extends Node2D

func add_corridor(target_corridor:Corridor):
	if get_corridor(target_corridor.zone_a,target_corridor.zone_b):
		return
	add_child(target_corridor)
func delete_corridor(target_corridor:Corridor):
	if target_corridor in get_children():
		target_corridor.zone_a.delete_succ(target_corridor.zone_b)
		target_corridor.zone_b.delete_pred(target_corridor.zone_a)
		target_corridor.queue_free()
func get_corridor(zone_a:Zone,zone_b:Zone):
	for i in get_children():
		if i.zone_a==zone_a and i.zone_b==zone_b:
			return i
	return null

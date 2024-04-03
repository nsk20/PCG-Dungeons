class_name Corridors
extends Node

func add_corridor(target_corridor:Corridor):
	if target_corridor in get_children():
		return
	add_child(target_corridor)
func delete_corridor(target_corridor:Corridor):
	if target_corridor in get_children():
		target_corridor.queue_free()
func get_corridor(zone_a:Zone,zone_b:Zone):#Be advised, will not check for multiple corridors with same end points
	for i in get_children():
		if i.zone_a==zone_a and i.zone_b==zone_b:
			return i
	return null
func make_corridor(zone_a:Zone,zone_b:Zone):
	var new_corridor=Corridor.new()
	new_corridor.zone_a=zone_a
	new_corridor.zone_b=zone_b
	return new_corridor
func update_depths():
	var update_incomplete=true
	while update_incomplete:
		update_incomplete=false
		for i in get_children():
			var prospective_depth=i.zone_a.depth+i.zone_b.depth_increment
			if prospective_depth<i.zone_b.depth:
				i.zone_b.depth=prospective_depth
				update_incomplete=true

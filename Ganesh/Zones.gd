class_name Zones
extends Node

func _process(delta):
	for i in get_children():
		for other in get_children():
			if i!=other:
				i.repel_zone(other)
				#i.repel_depth()
func add_zone(target_zone:Zone):
	if target_zone in get_children():
		return
	else:
		add_child(target_zone)
func delete_zone(target_zone:Zone):
	if target_zone in get_children():
		target_zone.queue_free()
func get_zone(zone_idx:String):
	for i in get_children():
		if i.zone_id==zone_idx:
			return i
	return null
func make_zone(zone_idx:String):
	var new_zone=Zone.new()
	new_zone.zone_id=zone_idx
	return new_zone
func reset_depths():
	for i in get_children():
		i.reset_depth()

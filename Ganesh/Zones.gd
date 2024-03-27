class_name Zones
extends Node

var entrance:DungeonZone

func _process(delta):
	for i in get_children():
		for other in get_children():
			if i!=other:
				i.repel_zone(other)
				#i.repel_depth()
func add_zone(target_zone:DungeonZone):
	if target_zone in get_children():
		return
	else:
		if get_child_count()==0:
			entrance=target_zone
		add_child(target_zone)
func delete_zone(target_zone:DungeonZone):
	if target_zone in get_children():
		target_zone.queue_free()
func get_zone(zone_idx:String):
	for i in get_children():
		if i.zone_id==zone_idx:
			return i
	return null
func make_zone(zone_idx:String):
	var new_zone=DungeonZone.new()
	new_zone.zone_id=zone_idx
	return new_zone

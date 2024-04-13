class_name Zones
extends Node2D

func _process(delta):
	repulse_zones()
func add_zone(target_zone:Zone):
	if get_zone(target_zone.zone_id):
		return
	else:
		add_child(target_zone)
func delete_zone(target_zone:Zone):
	if target_zone in get_children():
		target_zone.queue_free()
func get_zone(zone_id:String):
	for i in get_children():
		if i.zone_id==zone_id:
			return i
	return null
func repulse_zones():
	for i in get_children():
		for other in get_children():
			if i!=other:
				i.repel_zone(other)
func unexplore():
	for i in get_children():
		i.cleared=false

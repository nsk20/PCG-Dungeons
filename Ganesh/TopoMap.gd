class_name TopoMap
extends Node2D

func _ready():
	add_corridor('Start','Goal')
func add_corridor(zone_a_id:String,zone_b_id:String):
	add_zone(zone_a_id)
	add_zone(zone_b_id)
	var new_corridor=Corridor.new(get_zone(zone_a_id),get_zone(zone_b_id))
	$Corridors.add_corridor(new_corridor)
func add_zone(zone_id:String):
	$Zones.add_zone(zone_id)
func delete_corridor(zone_a_id:String,zone_b_id:String):
	$Corridors.delete_corridor(get_corridor(zone_a_id,zone_b_id))
func get_corridor(zone_a_id:String,zone_b_id:String):
	return $Corridors.get_corridor(get_zone(zone_a_id),get_zone(zone_b_id))
func get_zone(zone_id:String):
	return $Zones.get_zone(zone_id)
func unexplore():
	$Zones.unexplore()

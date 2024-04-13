class_name TopoMap
extends Node2D

func _input(event):
	if(event.is_action_released('ui_select')):
		insert_zone()
func _ready():
	add_corridor('Start','Goal')
func add_corridor(zone_a_id:String,zone_b_id:String):
	add_zone(zone_a_id)
	add_zone(zone_b_id)
	$Corridors.add_corridor(Corridor.new(get_zone(zone_a_id),get_zone(zone_b_id)))
func add_zone(zone_id:String):
	$Zones.add_zone(Zone.new(zone_id))
func delete_corridor(zone_a_id:String,zone_b_id:String):
	$Corridors.delete_corridor(get_corridor(zone_a_id,zone_b_id))
func get_corridor(zone_a_id:String,zone_b_id:String):
	return $Corridors.get_corridor(get_zone(zone_a_id),get_zone(zone_b_id))
func get_zone(zone_id:String):
	return $Zones.get_zone(zone_id)
func insert_zone():
	var corridors=$Corridors.get_children()
	var target_corridor=corridors[randi()%corridors.size()]
	var new_zone='Zone'+String.num($Zones.get_child_count())
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	add_corridor(target_corridor.zone_a.zone_id,new_zone)
	add_corridor(new_zone,target_corridor.zone_b.zone_id)
	get_zone(new_zone).position=midpoint
	delete_corridor(target_corridor.zone_a.zone_id,target_corridor.zone_b.zone_id)
func unexplore():
	$Zones.unexplore()

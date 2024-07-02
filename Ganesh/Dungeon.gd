class_name Dungeon
extends Node2D

func _input(event):
	if(event.is_action_released('ui_select')):
		var corridors=$'TopoMap/Corridors'.get_children()
		var target_corridor=corridors[randi()%corridors.size()]
		var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
		var pattern=randi()%3
		match pattern:
			0:
				var zone_a=target_corridor.zone_a.zone_id
				var zone_b=target_corridor.zone_b.zone_id
				var new_zone_1='Zone'+String.num($'TopoMap/Zones'.get_child_count())
				var new_zone_2='Zone'+String.num($'TopoMap/Zones'.get_child_count()+1)
				$TopoMap.add_corridor(zone_a,new_zone_1)
				$TopoMap.add_corridor(zone_a,new_zone_2)
				$TopoMap.add_corridor(new_zone_1,zone_b)
				$TopoMap.add_corridor(new_zone_2,zone_b)
				$TopoMap.get_zone(new_zone_1).position=midpoint
				$TopoMap.get_zone(new_zone_2).position=midpoint
				$TopoMap.delete_corridor(zone_a,zone_b)
			1:
				var new_zone='Zone'+String.num($'TopoMap/Zones'.get_child_count())
				$TopoMap.add_corridor(target_corridor.zone_a.zone_id,new_zone)
				$TopoMap.get_zone(new_zone).position=target_corridor.zone_a.position
			2:
				var new_zone='Zone'+String.num($'TopoMap/Zones'.get_child_count())
				$TopoMap.add_corridor(target_corridor.zone_a.zone_id,new_zone)
				$TopoMap.get_zone(new_zone).position=target_corridor.zone_a.position
				target_corridor.zone_b.key_zone=$TopoMap.get_zone(new_zone)
func _process(delta):
	position.x=get_window().size.x/2
	position.y=get_window().size.y/2

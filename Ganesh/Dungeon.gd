class_name Dungeon
extends Node2D

func _input(event):
	if(event.is_action_released('ui_select')):
		var corridors=$Corridors.get_children()
		var target_corridor=corridors[randi()%corridors.size()]
		var new_zone='DungeonZone'+String.num($Zones.get_child_count())
		var choose_pattern=randi()%4
		match choose_pattern:
			0:
				attach_zone(make_zone(new_zone),target_corridor)
			1:
				attach_pattern_altpath(target_corridor)
			2:
				attach_pattern_gambit(target_corridor)
			3:
				attach_pattern_lockcycle(target_corridor)
func _ready():
	add_zone(make_zone('Start'))
	get_zone('Start').depth=0
	add_zone(make_zone('Midway'))
	add_zone(make_zone('Goal'))
	add_corridor(get_zone('Start'),get_zone('Midway'))
	add_corridor(get_zone('Midway'),get_zone('Goal'))
func attach_pattern_altpath(target_corridor:DungeonCorridor):
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	var mid_zone_1=make_zone('DungeonZone'+String.num($Zones.get_child_count()))
	var mid_zone_2=make_zone('DungeonZone'+String.num($Zones.get_child_count()))
	mid_zone_1.position=midpoint
	mid_zone_2.position=midpoint
	add_corridor(target_corridor.zone_a,mid_zone_1)
	add_corridor(target_corridor.zone_a,mid_zone_2)
	add_corridor(mid_zone_1,target_corridor.zone_b)
	add_corridor(mid_zone_2,target_corridor.zone_b)
	delete_corridor(target_corridor)
func attach_pattern_gambit(target_corridor:DungeonCorridor):
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	var reward_zone=make_zone('DungeonZone'+String.num($Zones.get_child_count()))
	reward_zone.position=midpoint
	add_corridor(target_corridor.zone_a,reward_zone)
func attach_pattern_lockcycle(target_corridor:DungeonCorridor):
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	var key_zone=make_zone('DungeonZone'+String.num($Zones.get_child_count()))
	key_zone.position=midpoint
	add_corridor(target_corridor.zone_b,key_zone)
	add_corridor(key_zone,target_corridor.zone_a)
func attach_zone(zone_to_attach:DungeonZone,target_corridor:DungeonCorridor):
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	zone_to_attach.position=midpoint
	add_corridor(target_corridor.zone_a,zone_to_attach)
	add_corridor(zone_to_attach,target_corridor.zone_b)
	delete_corridor(target_corridor)
func add_corridor(zone_a:DungeonZone,zone_b:DungeonZone):
	add_zone(zone_a)
	add_zone(zone_b)
	$Corridors.add_corridor($Corridors.make_corridor(zone_a,zone_b))
func add_zone(zone_to_add:DungeonZone):
	$Zones.add_zone(zone_to_add)
func delete_corridor(target_corridor:DungeonCorridor):
	$Corridors.delete_corridor(target_corridor)
func delete_zone(target_zone:DungeonZone):
	$Zones.delete_zone(target_zone)
func get_corridor(zone_a:DungeonZone,zone_b:DungeonZone):
	return $Corridors.get_corridor(zone_a,zone_b)
func get_zone(zone_idx:String):
	return $Zones.get_zone(zone_idx)
func make_zone(zone_idx:String):
	return $Zones.make_zone(zone_idx)

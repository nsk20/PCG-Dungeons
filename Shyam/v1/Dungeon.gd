class_name Dungeon
extends Node2D

func _input(event):
	if(event.is_action_released('ui_select')):
		var corridors=$Corridors.get_children()
		var target_corridor=corridors[randi()%corridors.size()]
		var new_zone='DungeonZone'+String.num($Zones.get_child_count())
		attach_zone(make_zone(new_zone),target_corridor)
func _process(_delta):
	for i in $Corridors.get_children():
		i.attract_zones()
	for i in $Zones.get_children():
		for other in $Zones.get_children():
			if i!=other:
				i.repel_zone(other)
				i.repel_depth()
	for i in $Corridors.get_children():
		i.update_line()
	for i in $Zones.get_children():
		i.update_position()
func _ready():
	visible=false#BUG Unclear why, but Dungeon appears to be inheriting _draw() from DungeonZone, despite neither being the other's superclass
	add_zone(make_zone('Start'))
	get_zone('Start').fixed=true
	get_zone('Start').depth=0
	add_zone(make_zone('Midway'))
	add_zone(make_zone('Goal'))
	add_corridor(get_zone('Start'),get_zone('Midway'))
	add_corridor(get_zone('Midway'),get_zone('Goal'))
func attach_zone(zone_to_attach:DungeonZone,target_corridor:DungeonCorridor):
	var midpoint=(target_corridor.zone_a.position+target_corridor.zone_b.position)/2
	zone_to_attach.position=midpoint
	add_corridor(target_corridor.zone_a,zone_to_attach)
	add_corridor(zone_to_attach,target_corridor.zone_b)
	delete_corridor(target_corridor)
func add_corridor(zone_a:DungeonZone,zone_b:DungeonZone):
	add_zone(zone_a)
	add_zone(zone_b)
	var new_corridor=$DungeonCorridor.duplicate()
	new_corridor.zone_a=zone_a
	new_corridor.zone_b=zone_b
	$Corridors.add_child(new_corridor)
func add_zone(zone_to_add:DungeonZone):
	if zone_to_add in $Zones.get_children():
		return
	else:
		zone_to_add.position=zone_to_add.position+Vector2(randi()%10,randi()%10)
		$Zones.add_child(zone_to_add)
func delete_corridor(target_corridor:DungeonCorridor):
	target_corridor.queue_free()
func get_corridor(zone_a:DungeonZone,zone_b:DungeonZone):
	for i in $Corridors.get_children():
		if i.zone_a==zone_a and i.zone_b==zone_b:
			return i
	return null
func get_zone(zone_idx:String):
	for i in $Zones.get_children():
		if i.id==zone_idx:
			return i
	return null
func make_zone(zone_idx:String):
	var new_zone=$DungeonZone.duplicate()
	new_zone.id=zone_idx
	return new_zone

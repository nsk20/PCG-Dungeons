class_name Adventurer
extends Node2D

var destination:DungeonZone

func _draw():
	draw_circle(Vector2.ZERO,30,Color.RED)
func _process(delta):
	if destination:
		var pos_diff=destination.position-position
		if pos_diff.length()>.1:
			position+=pos_diff.normalized()
		else:
			wander()
	else:
		destination=$'../Zones'.entrance
func wander():
	var potential_destinations=[]
	for i in $'../Corridors'.get_children():
		if i.zone_a==destination:
			potential_destinations.append(i.zone_b)
	if potential_destinations.size()<1:
		destination=$'../Zones'.entrance
		position=destination.position
	else:
		var new_destination=potential_destinations[randi()%potential_destinations.size()]
		destination=new_destination

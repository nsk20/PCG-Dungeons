class_name Adventurer
extends Node2D

var destination:Zone
var map:TopoMap
var prev_destination:Zone

func _draw():
	draw_circle(Vector2.ZERO,5,Color.RED)
func _process(delta):
	if destination:
		var pos_diff=destination.position-position
		if pos_diff.length()>1:
			position+=pos_diff.normalized()
		else:
			destination.clear_attempt()
			if destination.cleared:
				if destination.zone_id=='Goal':
					destination=map.get_zone('Start')
					position=destination.position
					map.unexplore()
				else:
					wander()
			else:
				destination=prev_destination
	else:
		destination=map.get_zone('Start')
func _ready():
	map=get_node('../TopoMap')
func wander():
	var potential_destinations=[]
	for i in destination.predecessors:
		potential_destinations.append(i)
	for i in destination.successors:
		potential_destinations.append(i)
	prev_destination=destination
	destination=potential_destinations[randi()%potential_destinations.size()]

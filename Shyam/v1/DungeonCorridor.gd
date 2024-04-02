class_name DungeonCorridor
extends Line2D

var zone_a:DungeonZone
var zone_b:DungeonZone

var length:int=1000
var springiness:float=.001

func _process(delta):
	queue_redraw()
func attract_zones():
	var distance=zone_b.position-zone_a.position
	var adjustment=distance.normalized()*(springiness*(distance.length()-length))
	zone_a.velocity+=adjustment
	zone_b.velocity+=-adjustment
func update_depth():
	var new_depth=zone_a.depth+zone_a.depth_increment
	if zone_b.depth<new_depth:
		zone_b.depth=new_depth
func update_line():
	clear_points()
	add_point(zone_a.position)
	add_point(zone_b.position)

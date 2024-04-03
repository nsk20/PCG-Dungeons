class_name Corridor
extends Line2D

var zone_a:Zone
var zone_b:Zone

var length:int=1000
var springiness:float=.001

func _process(delta):
	attract_zones()
	update_line()
	queue_redraw()
func _ready():
	gradient=Gradient.new()
func attract_zones():
	var distance=zone_b.position-zone_a.position
	var adjustment=distance.normalized()*(springiness*(distance.length()-length))
	zone_a.velocity+=adjustment
	zone_b.velocity+=-adjustment
func update_line():
	clear_points()
	add_point(zone_a.position)
	add_point(zone_b.position)

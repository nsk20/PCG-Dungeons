class_name Corridor
extends Line2D

var zone_a:Zone
var zone_b:Zone

var length:int=100

func _init(zone_ax:Zone,zone_bx:Zone):
	zone_a=zone_ax
	zone_b=zone_bx
	gradient=Gradient.new()
func _process(delta):
	#attract_zones()
	update_line()
	queue_redraw()
func _ready():
	zone_a.add_succ(zone_b)
	zone_b.add_pred(zone_a)
func attract_zones():
	var distance=zone_b.position-zone_a.position
	var adjustment=distance.normalized()*(distance.length()-length)*.01
	zone_a.velocity+=adjustment
	zone_b.velocity+=-adjustment
func update_line():
	clear_points()
	add_point(zone_a.position)
	add_point(zone_b.position)

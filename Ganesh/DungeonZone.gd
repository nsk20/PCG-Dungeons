class_name DungeonZone
extends Node2D

var zone_id:String
var depth:int=2**63-1
var depth_increment:int=1

var radius:int=100
var personal_space:int=1000
var velocity:Vector2=Vector2.ZERO
var springiness:int=.001
var fixed:bool=false

func _draw():
	draw_circle(Vector2.ZERO,radius,Color.BLACK)
func _process(delta):
	update_position()
	queue_redraw()
func repel_zone(other_zone:DungeonZone):
	if position.distance_to(other_zone.position)>radius+personal_space:
		return
	if position==other_zone.position:
		velocity+=Vector2(randi()%3-1,randi()%3-1)
	velocity+=-position.direction_to(other_zone.position)
func update_position():
	if not fixed:
		position+=velocity
	velocity=Vector2.ZERO
func repel_depth():
	var distance=position-Vector2.ZERO
	var adjustment=distance.normalized()*(springiness*(distance.length()-depth))
	velocity+=adjustment
	velocity+=-adjustment

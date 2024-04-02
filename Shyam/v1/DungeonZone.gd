class_name DungeonZone
extends Node2D

var id:String
var depth:int=2**63-1
var depth_increment:int=1

export var radius:int=100
export var personal_space:int=1000
export var velocity:Vector2=Vector2.ZERO
export var springiness:int=.001
export var fixed:bool=false

func _draw():
	draw_circle(Vector2.ZERO,radius,Color.BLACK)
func _process(delta):
	queue_redraw()
func repel_zone(other_zone:DungeonZone,reversed:bool=false):
	if fixed or position.distance_to(other_zone.position)>radius+personal_space:
		return
	velocity+=-position.direction_to(other_zone.position)
func update_position():
	if not fixed:
		position+=velocity
	velocity=Vector2.ZERO
func repel_depth():
	if fixed:
		return
	var distance=position-Vector2.ZERO
	var adjustment=distance.normalized()*(springiness*(distance.length()-depth))
	velocity+=adjustment
	velocity+=-adjustment

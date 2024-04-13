class_name Zone
extends Node2D

signal updated_depth

var cleared:bool=false
var depth:int=0
var fixed=false
var predecessors:Array[Zone]=[]
var radius:int=50
var space_buffer:int=radius*3
var successors:Array[Zone]=[]
var velocity:Vector2
var zone_id:String

func _draw():
	if cleared:
		draw_circle(Vector2.ZERO,radius*1.5,Color.WHITE/(depth+1))
	draw_circle(Vector2.ZERO,radius,Color.BLACK/(depth+1))
func _init(zone_idx:String):
	zone_id=zone_idx
func _process(delta):
	if predecessors.is_empty():
		fixed=true
	update_position()
	queue_redraw()
func _on_zone_updated_depth():
	var new_depth=2**63-1
	if predecessors.is_empty():
		new_depth=0
	for i in predecessors:
		var prospective_depth=i.depth+1
		if prospective_depth<new_depth:
			new_depth=prospective_depth
	if depth!=new_depth:
		depth=new_depth
		updated_depth.emit()
func _ready():
	_on_zone_updated_depth()
func add_pred(other_zone:Zone):
	if not other_zone in predecessors:
		predecessors.append(other_zone)
	other_zone.updated_depth.connect(_on_zone_updated_depth)
	_on_zone_updated_depth()
func add_succ(other_zone:Zone):
	if not other_zone in successors:
		successors.append(other_zone)
func clear_attempt():
	if randf()<1.0/min(1,depth):
		cleared=true
func delete_pred(other_zone:Zone):
	if other_zone in predecessors:
		predecessors.erase(other_zone)
		other_zone.updated_depth.disconnect(_on_zone_updated_depth)
		_on_zone_updated_depth()
func delete_succ(other_zone:Zone):
	if other_zone in successors:
		successors.erase(other_zone)
func update_position():
	if not fixed:
		position+=velocity
	velocity=Vector2.ZERO
func repel_zone(other_zone:Zone):
	if position.distance_to(other_zone.position)>radius+space_buffer:
		return
	if position.x==other_zone.position.x:
		velocity+=Vector2(randi()%3-1,0)
	if position.y==other_zone.position.y:
		velocity+=Vector2(0,randi()%3-1)
	velocity+=-position.direction_to(other_zone.position).normalized()*.005

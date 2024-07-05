class_name Mouseover
extends Label

func _input(event):
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
		for zone in get_node('../TopoMap/Zones').get_children():
			if (event.position-zone.global_position).length()<zone.radius:
				zone.selected=true
				text=zone.zone_id+'\n'
				text+='Depth: '+str(zone.depth)+'\n'
				if zone.key_zone:
					text+='Key: '+zone.key_zone.zone_id+'\n'
				text+='Predecessors:\n'
				text+='\t'
				for i in zone.predecessors:
					text+=i.zone_id+' '
				text+='\n Successors:\n'
				text+='\t'
				for i in zone.successors:
					text+=i.zone_id+' '
			else:
				zone.selected=false
func _process(delta):
	position.x=get_window().size.x*3/10
	position.y=-get_window().size.y*3/10

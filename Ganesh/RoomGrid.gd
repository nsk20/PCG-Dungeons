class_name RoomGrid
extends Node2D

var expanded:bool=false
var grid:Array
var fill=.45

func _draw():
	if not expanded:
		return
	for a in range(grid.size()):
		for b in range(grid[a].size()):
			if grid[a][b]==0:
				draw_rect(Rect2(Vector2(a*30,b*30),Vector2(30,30)),Color.WHITE,false)
			if grid[a][b]==1:
				draw_rect(Rect2(Vector2(a*30,b*30),Vector2(30,30)),Color.BLACK)
func _ready():
	grid=[]
	for a in range(10):
		var new_piece=[]
		for b in range(10):
			if randf()<fill:
				new_piece.append(1)
			else:
				new_piece.append(0)
		grid.append(new_piece)

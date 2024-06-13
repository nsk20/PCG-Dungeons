class_name MonteCarloSearch
extends Node

var root

func _init():
	root=MonteCarloSearchNode.new()
	root.state=TicTacToeState.new()
func explore(runs:int=10,depth:int=10):
	for i in range(runs):
		root.visit(depth)
func play_move():
	if root.optimal_move():
		root=root.optimal_move()

class_name Test
extends Node

func _ready():
	var mcts=MonteCarloSearch.new()
	for i in range(10):
		mcts.explore(10,10)
		mcts.root.print_self()
		mcts.play_move()

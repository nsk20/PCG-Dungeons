class_name MonteCarloSearchNode
extends Node

var children:Array[MonteCarloSearchNode]=[]
var priority
var state
var is_terminal=false
var value=0
var visit_count=0

func calc_is_terminal():
	is_terminal=state.check_is_terminal()
func calc_priority():
	priority=value/visit_count
func calc_value():
	if children.is_empty():
		value=position_value()
	else:
		value=0
		for i in children:
			value+=i.value
func expand():
	for i in state.gen_moves():
		var new_search_node=MonteCarloSearchNode.new()
		new_search_node.state=i
		children.append(new_search_node)
func optimal_move():
	if not is_terminal and not children.is_empty():
		var opti_index=0
		for i in range(children.size()):
			if children[i].visit_count>children[opti_index].visit_count:
				opti_index=i
		return children[opti_index]
func print_search_locale():
	print_self()
	print('///')
	for i in children:
		i.print_self()
func print_self():
	state.print_board()
	print(value,' value')
	print(visit_count,' visits')
	print(priority,' priority')
	if is_terminal:
		print('TERMINUS')
func select_rollout():
	var choice=randi_range(0,children.size()-1)
	return children[choice]
func position_value():
	if state.is_x_winner() and not state.is_x_turn:
		return 1
	elif state.is_o_winner() and state.is_x_turn:
		return 1
	else:
		return 0
func visit(max_depth:int):
	calc_is_terminal()
	if is_terminal or max_depth==0:
		calc_value()
		visit_count+=1
		calc_priority()
		return
	if children.is_empty():
		expand()
	select_rollout().visit(max_depth-1)
	calc_value()
	visit_count+=1
	calc_priority()

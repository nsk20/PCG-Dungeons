class_name MCTSAdventurer
extends Node2D

var map: TopoMap
var current_zone: Zone
var goal_zone: Zone
var start_zone: Zone
var iterations: int = 1000  # Number of MCTS iterations per move
var total_moves: int = 0
var total_playthroughs: int = 0
var is_active: bool = false
const PT_LIMIT: int = 2 # Limit the number of play-throughs
signal stop_process

var activate_button: Button
var can_press_button = true

class MCTSNode:
	var zone: Zone
	var parent: MCTSNode
	var children: Array[MCTSNode]
	var visits: int = 0
	var value: float = 0.0
	var untried_actions: Array[Zone]

	func _init(z: Zone, p: MCTSNode = null):
		zone = z
		parent = p
		untried_actions = z.successors + z.predecessors

	func uct_value(parent_visits: int) -> float:
		if visits == 0:
			return INF
		return (value / visits) + sqrt(2 * log(parent_visits) / visits)

	func best_child() -> MCTSNode:
		var best_value = -INF
		var best_node: MCTSNode = null
		for child in children:
			var uct = child.uct_value(visits)
			if uct > best_value:
				best_value = uct
				best_node = child
		return best_node

func _ready():
	map = get_node("../TopoMap")
	start_zone = map.get_zone("Start")
	goal_zone = map.get_zone("Goal")
	reset_game()
	
	# Activation button
	if not activate_button:
		create_activate_button()

func create_activate_button():
	activate_button = Button.new()
	activate_button.text = "Activate MCTS Agent"
	# Change Position of button
	activate_button.position = Vector2(-500, -300)  
	activate_button.connect("pressed", Callable(self, "_on_activate_button_pressed"))
	add_child(activate_button)

func _on_activate_button_pressed():
	if not can_press_button:
		return
	
	can_press_button = false
	stop_process.emit()
	print("Button Pressed!")
	is_active = !is_active
	update_button_text()
	
	# Timer to prevent rapid button presses
	var timer = Timer.new()
	timer.connect("timeout", Callable(self, "_on_button_cooldown_timeout"))
	timer.set_one_shot(true)
	timer.set_wait_time(0.5)  # Half-second cooldown
	add_child(timer)
	timer.start()    

func _on_button_cooldown_timeout():
	can_press_button = true

func update_button_text():
	if is_active:
		activate_button.text = "Deactivate MCTS Agent"
		print("MCTS Adventurer activated!")
	else:
		activate_button.text = "Activate MCTS Adventurer"
		print("MCTS Adventurer deactivated.")

func _process(delta):
	if not is_active:
		return
	elif total_playthroughs == PT_LIMIT:
		print("Playthrough Limit Reached!")
		is_active = !is_active
		update_button_text()
		return 
	if current_zone != goal_zone:
		var next_zone = mcts_decision()
		move_to(next_zone)
		total_moves += 1
	else:
		print("Goal reached in ", total_moves, " moves!")
		total_playthroughs += 1
		print("Total playthroughs: ", total_playthroughs)
		reset_game()
	
	# Ensure the button stays in place
	if activate_button:
		activate_button.position = Vector2(-500, -300)
	
	# Only update the entire node if necessary
	queue_redraw()

func reset_game():
	current_zone = start_zone
	position = current_zone.position
	map.unexplore()
	total_moves = 0

func mcts_decision() -> Zone:
	var root = MCTSNode.new(current_zone)
	
	for i in range(iterations):
		var node = tree_policy(root)
		var reward = default_policy(node.zone)
		backpropagate(node, reward)
	
	return best_child(root).zone

func tree_policy(node: MCTSNode) -> MCTSNode:
	while not is_terminal(node.zone):
		if not node.untried_actions.is_empty():
			return expand(node)
		else:
			node = node.best_child()
	return node

func expand(node: MCTSNode) -> MCTSNode:
	var action = node.untried_actions.pop_back()
	var child = MCTSNode.new(action, node)
	node.children.append(child)
	return child

func default_policy(zone: Zone) -> float:
	var current = zone
	var depth = 0
	while not is_terminal(current) and depth < 10:  # Limit simulation depth
		var next_zones = current.successors + current.predecessors
		current = next_zones[randi() % next_zones.size()]
		depth += 1
	return evaluate(current, depth)

func backpropagate(node: MCTSNode, reward: float):
	while node != null:
		node.visits += 1
		node.value += reward
		node = node.parent

func best_child(node: MCTSNode) -> MCTSNode:
	var best_value = -INF
	var best_nodes: Array[MCTSNode] = []
	
	for child in node.children:
		var value = child.visits
		if value > best_value:
			best_value = value
			best_nodes = [child]
		elif value == best_value:
			best_nodes.append(child)
	
	return best_nodes[randi() % best_nodes.size()]

func is_terminal(zone: Zone) -> bool:
	return zone == goal_zone

func evaluate(zone: Zone, depth: int) -> float:
	if zone == goal_zone:
		return 1.0 / (depth + 1)  # Reward reaching the goal, with preference for shorter paths
	return 0.0

func move_to(zone: Zone):
	current_zone = zone
	position = zone.position
	zone.clear_attempt()

func _draw():
	if is_active:
		draw_circle(Vector2.ZERO, 5, Color.BLUE)
	else:
		draw_circle(Vector2.ZERO, 5, Color.GRAY)

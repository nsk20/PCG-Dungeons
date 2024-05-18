import random, time

class MCTS:
    def __init__(self, mdp, qfunc, bandit):
        self.mdp = mdp
        self.qfunction = qfunc
        self.bandit = bandit


    def mcts(self, timeout=1, root_node=None):
        """
        MCTS algorithm from the initial state given; timed -> seconds
        """
        if root_node is None:
            root_node = self.create_root_node()

        start_time = time.time()
        current_time = time.time()
        while current_time < start_time + timeout:

            # Find a state node to expand
            selected_node = root_node.select()
            if not self.mdp.is_terminal(selected_node):

                child = selected_node.expand()
                reward = self.simulate(child)
                selected_node.back_propagate(reward, child)

            current_time = time.time()

        return root_node


    def create_root_node(self):
         """
         Create a root node representing an initial state 
         """
         pass

    def choose(self, state):
        """
        Choose a random action. Heustics can be used here to improve simulations.
        """
        return random.choice(self.mdp.get_actions(state))

    """ Simulate until a terminal state """

    def simulate(self, node):
        state = node.state
        cumulative_reward = 0.0
        depth = 0
        while not self.mdp.is_terminal(state):
            # Choose an action to execute
            action = self.choose(state)

            # Execute the action
            (next_state, reward, done) = self.mdp.execute(state, action)

            # Discount the reward
            cumulative_reward += pow(self.mdp.get_discount_factor(), depth) * reward
            depth += 1

            state = next_state

        return cumulative_reward
import math

class Node:
    def __init__(self, state=None):
        self.q_value = 0      # Sum of returns by transversals through this node.
        self.n_visits = 0     # Number of node visits
        self.state = state    # Game state
        self.children = []    # List of children-states

    # UCB1 score for exploration/exploitation trade off.
    def get_child_ucb1(self, child):
        if child.n_visits == 0:
            return float("inf")
        return child.q_value / child.n_visits + 2 * math.sqrt(math.log(self.n_visits, math.e) / child.n_visits)

    # Selection Method
    def get_max_ucb1_child(self):
        if not self.children:
            return None

        max_i = 0
        max_ucb1 = float("-inf")

        for i, child in enumerate(self.children):
            ucb1 = self.get_child_ucb1(child)

            if ucb1 > max_ucb1:
                max_ucb1 = ucb1
                max_i = i

        return self.children[max_i], max_i
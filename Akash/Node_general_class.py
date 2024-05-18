import math, time, random
from collections import defaultdict

class Node:
    # Why do nodes need to be connected? Duplicated states
    next_node_id = 0

    #N(s) = number of times the current node has been visited
    n_s = defaultdict(lambda:0)

    def __init__(self, state, parent, mdp, qfunc, bandit, reward=0.0, action=None):
        self.state = state
        self.parent = parent
        self.mdp = mdp
        
        # Adjusting for duplicated states
        self.id = Node.next_node_id
        Node.next_node_id += 1

        #Q-Function: (action, state) value
        self.qfunc = qfunc

        #Multi-arm Bandit
        self.bandit = bandit

        #Immediate reward after reaching current node
        self.reward = reward
        
        # Action that lead to the current node
        self.action = action


    def select(self): 
        """ 
        Select a node that is not fully expanded
        """
        pass

    def expand(self): 
        """
        Expand a node if it is not a terminal node 
        """
        pass

    def back_propagate(self, reward, child): 
        """
        Backpropogate the reward back to the parent node
        """
        pass

    def get_value(self):
        """
        Return the value of this node
        """
        max_q_value = self.qfunction.get_max_q(
                self.state, self.mdp.get_actions(self.state)
            )
        return max_q_value

    def get_visits(self):
        """ Get the number of visits to this state """
        return Node.visits[self.state]
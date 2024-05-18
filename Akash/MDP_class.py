class MDP:
    def get_states(self):
        """ Return all states of this MDP """
        pass

    def get_actions(self, state):
        """ Return all actions with non-zero probability from this state """
        pass

    
    def get_transitions(self, state, action):
        """ 
        Return all non-zero probability transitions for this action
        from this state, as a list of (state, probability) pairs
        """
        pass

    def get_reward(self, state, action, next_state):
        """ 
        Return the reward for transitioning from state to nextState via action
        """
        pass

    def is_terminal(self, state):
        """ 
        Return true if and only if state is a terminal state of this MDP 
        """
        pass

    def get_discount_factor(self):
        """ 
         Return the discount factor for this MDP 
        """
        pass

    
    def get_initial_state(self):
        """ 
        Return the initial state of this MDP 
        """
        pass

    def get_goal_states(self):
        """ 
        Return all goal states of this MDP 
        """
        pass
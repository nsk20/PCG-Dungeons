import math

class MultiArmedBandit():

    def select(self, state, actions, qfunction):
        """
        Select an action for this state given from a list given a Q-function
        """
        pass

    def reset(self):
        """
        Reset a multi-armed bandit to its initial configuration
        """
        self.__init__()
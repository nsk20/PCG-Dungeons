import random, copy
import numpy as np
from mcts_pendulum_node import Node

class MCTS:
    def __init__(self, env, reset=False):
        self.env = env
        if reset:
            start_state, _ = self.env.reset()
        else:
            start_state = self.env.unwrapped.state
        self.start_env = copy.deepcopy(self.env)
        self.root_node = Node(start_state)

        for act in range(self.env.action_space.n):
            env_copy = copy.deepcopy(self.env)
            new_state, _, _, _, _ = env_copy.step(act)
            new_node = Node(new_state)
            self.root_node.children.append(new_node)

    # Run `n_iter` number of iterations
    def run(self, n_iter=200):
        for _ in range(n_iter):
            q_value, node_path = self.traverse()
            self.backpropagate(node_path, q_value)
            self.env = copy.deepcopy(self.start_env)

        vals = [float("-inf")] * self.env.action_space.n
        for i, child in enumerate(self.root_node.children):
            vals[i] = (child.q_value / child.n_visits) if child.n_visits else 0

        return np.exp(vals) / sum(np.exp(vals))

    def traverse(self):
        cur_node = self.root_node
        node_path = [cur_node]
        while cur_node.children:
            cur_node, idx = cur_node.get_max_ucb1_child()
            self.env.step(idx)
            node_path.append(cur_node)

        if cur_node.n_visits:
            for act in range(self.env.action_space.n):
                env_copy = copy.deepcopy(self.env)
                new_state, _, _, _, _ = env_copy.step(act)
                new_node = Node(new_state)
                cur_node.children.append(new_node)
                
            cur_node, idx = cur_node.get_max_ucb1_child()
            self.env.step(idx)
            node_path.append(cur_node)

        return self.rollout(), node_path

    def rollout(self) -> float:
        tot_reward = 0

        while True:
            act = random.randrange(self.env.action_space.n)
            _, reward, done, _, _ = self.env.step(act)
            tot_reward += reward

            if done:
                break

        return tot_reward

    def backpropagate(self, node_path: list, last_value: float):
        for node in node_path[::-1]:
            node.q_value += last_value
            node.n_visits += 1
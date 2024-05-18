import random, copy
import gymnasium as gym
from mcts_pendulum_class import MCTS

env = gym.make('CartPole-v1')
env.reset()
    
done = False
tot_reward = 0
    
while not done:
    mcts = MCTS(copy.deepcopy(env), reset=False)
    probs = mcts.run(20)
    action = random.choices(range(len(probs)), weights=probs, k=1)[0]
        
    _, reward, done, _, _ = env.step(action)
    tot_reward += reward
    print(f"Reward: {tot_reward}   ", end='\r')
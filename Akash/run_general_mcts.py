#Note: need to implement other classes, currently not running

from gridworld import GridWorld
from graph_visualisation import GraphVisualisation
from QT_general_class import QTable
from SNA_general_class import SingleAgentMCTS
#from q_policy import QPolicy
from UCB1_general_class import UpperConfidenceBounds

gridworld = GridWorld()
qfunction = QTable()
root_node = SingleAgentMCTS(gridworld, qfunction, UpperConfidenceBounds()).mcts(timeout=0.03)
gv = GraphVisualisation(max_level=6)
graph = gv.single_agent_mcts_to_graph(root_node, filename="mcts")
graph
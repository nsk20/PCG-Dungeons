#Contains the Following Utility Functions to perform:
# 1. Line-of-Sight and Field-of-View
# 2. A* algorithm for find optimal path between points
#Using coordinates like matrix indices (row, column)

import heapq

def bresenham_line(x0, y0, x1, y1):
    cells = []
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    x, y = x0, y0
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    
    if dx > dy:
        err = dx / 2.0
        while x != x1:
            cells.append((x, y))
            err -= dy
            if err < 0:
                y += sy
                err += dx
            x += sx
    else:
        err = dy / 2.0
        while y != y1:
            cells.append((x, y))
            err -= dx
            if err < 0:
                x += sx
                err += dy
            y += sy
    
    cells.append((x, y))
    return cells

# Index Conversion:
# Matrix cell indices: (row, column)
# Bresenham coordicates: (x -> column, y -> row) 


def has_line_of_sight(x0, y0, x1, y1, dungeon_map):
    # Use above conversion
    cells = bresenham_line(y0, x0, y1, x1)

    for x, y in cells[1:-1]:  # Exclude start and end points
        # converting back from bresenham coordinates to matrix indices
        if dungeon_map[y][x] == '#':  # Assuming '#' represents a wall
            return False
    return True


# Not need for MiniDungeon2. Only pass list of combinations of (MPC, NPC) to check at every move.
def calculate_fov(x, y, radius, dungeon_map):
    visible = set()
    for dx in range(-radius, radius + 1):
        for dy in range(-radius, radius + 1):
            if dx*dx + dy*dy <= radius*radius:  # Check if within circular radius
                if has_line_of_sight(x, y, x+dx, y+dy, dungeon_map):
                    visible.add((x+dx, y+dy))
    return visible



class Node:
    def __init__(self, position, g_cost, h_cost, parent):
        self.position = position
        self.g_cost = g_cost
        self.h_cost = h_cost
        self.f_cost = g_cost + h_cost
        self.parent = parent

    def __lt__(self, other):
        return self.f_cost < other.f_cost

def manhattan_distance(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])

def get_neighbors(grid, node):
    neighbors = []
    for dx, dy in [(0, 1), (1, 0), (0, -1), (-1, 0)]:  # 4-directional movement
        new_position = (node.position[0] + dx, node.position[1] + dy)
        if (0 <= new_position[0] < len(grid) and 
            0 <= new_position[1] < len(grid[0]) and 
            grid[new_position[0]][new_position[1]] != '#'):  # '#' represents wall/obstacle
            neighbors.append(new_position)
    return neighbors

def a_star(grid, start, goal):
    start_node = Node(start, 0, manhattan_distance(start, goal), None)
    open_list = [start_node]
    closed_set = set()

    while open_list:
        current_node = heapq.heappop(open_list)

        if current_node.position == goal:
            path = []
            while current_node:
                path.append(current_node.position)
                current_node = current_node.parent
            return path[::-1]  # Return reversed path

        closed_set.add(current_node.position)

        for neighbor_pos in get_neighbors(grid, current_node):
            if neighbor_pos in closed_set:
                continue

            neighbor = Node(neighbor_pos,
                            current_node.g_cost + 1,
                            manhattan_distance(neighbor_pos, goal),
                            current_node)

            if neighbor not in open_list:
                heapq.heappush(open_list, neighbor)
            else:
                idx = open_list.index(neighbor)
                if open_list[idx].g_cost > neighbor.g_cost:
                    open_list[idx] = neighbor
                    heapq.heapify(open_list)

    return None  # No path found


#def generate_a_star(grid, start, goal):

# Example usage
grid = [
    [0, 0, 0, 0, 1],
    [1, 1, 0, 0, 0],
    [0, 0, 0, 1, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 0, 1, 0]
]

start = (0, 0)
goal = (4, 4)

path = a_star(grid, start, goal)

if path:
    print("Path found:", path)
    # Visualize the path
    for i, row in enumerate(grid):
        for j, cell in enumerate(row):
            if (i, j) == start:
                print("S", end=" ")
            elif (i, j) == goal:
                print("G", end=" ")
            elif (i, j) in path:
                print("*", end=" ")
            elif cell == 1:
                print("#", end=" ")
            else:
                print(".", end=" ")
        print()
else:
    print("No path found")


###### Map Moves to Matrix Coordinates

def move_to_coor(move):
    """
    Converts moves to change in matrix indices.
    Javelin Needs to be implemented.
    Default returns "(0, 0)".
    """
    # Change in 2D Matrix indices
    match move:
        case "U":
            return (-1, 0)
        case "D":
            return (1, 0)
        case "L":
            return (0, -1)
        case "R":  
            return (0, 1)
        case "J":
            return (20, 20)
        case _:  # Default case
            return (0, 0)


board_1 = [
  ['#', '#', '#', '#', '#', '#', '#', '#', '#', '#'], # 0
  ['#', "M", '.', '.', '@', '.', '.', 'g', 'G', '#'], # 1 
  ['#', '#', '#', '#', '#', '.', '.', '#', '#', '#'], # 2
  ['#', 'w', '.', '.', '.', '.', '.', '.', 'P', '#'], # 3
  ['#', 'g', '.', '.', '.', '.', '#', '#', 'G', '#'], # 4
  ['#', '#', '#', '#', '#', '.', '#', '#', '#', '#'], # 5
  ['#', 'P', '.', '.', 'g', '.', 'g', '.', '.', '#'], # 6
  ['#', '#', '#', '#', '.', '#', '#', '#', '#', '#'],
  ['#', '.', '.', 'T', '.', '.', '.', '.', 'A', '#'],
  ['#', '.', '#', '#', '.', '#', '#', '#', '.', '#'],
  ['#', '.', '#', 'b', '.', 'b', '.', '.', '.', '#'],
  ['#', '.', '#', '.', '#', '#', '#', '#', '#', '#'],
  ['#', '.', '.', '.', '.', '.', '.', '.', '.', '#'],
  ['#', '#', '#', '#', '#', '#', '#', '#', '.', '#'],
  ['#', 'g', '.', '.', '.', '.', '.', '.', '.', '#'],
  ['#', '.', '#', '#', '.', '.', '#', '#', '.', '#'],
  ['#', '.', '#', '#', '.', '.', '#', '#', '.', '#'],
  ['#', '.', '.', 'g', '.', '.', 'g', '.', '.', '#'],
  ['#', 'B', '.', '.', '.', '.', '.', '.', '.', 'E'],
  ['#', '#', '#', '#', '#', '#', '#', '#', '#', '#']
] #  0,   1,   2,   3,   4,   5,   6,   7,  8,   9,


"""
print(has_line_of_sight(1, 4, 1, 1, board_1))  # True
print(has_line_of_sight(1, 4, 3, 5, board_1))  # False
print(has_line_of_sight(1, 4, 3, 6, board_1))  # True
print(has_line_of_sight(1, 4, 3, 7, board_1))  # True
print(has_line_of_sight(1, 4, 3, 8, board_1))  # False
print(has_line_of_sight(1, 4, 6, 7, board_1))  # False
"""
#Contains the Following Utility Functions to perform:
# 1. Line-of-Sight and Field-of-View
# 2. A* algorithm for find optimal path between points
#Using coordinates like matrix indices (row, column)

import heapq
from char_const import *
from char_objs import *

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

##### A* Implementation #####

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
            grid[new_position[0]][new_position[1]] != '#  '):  # '#' represents wall/obstacle
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


board_1 = [
  ['#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  '], # 0
  ['#  ', "M  ", '.  ', '.  ', '@+J', '.  ', '.  ', 'g  ', 'G  ', '#  '], # 1 
  ['#  ', '#  ', '#  ', '#  ', '#  ', '.  ', '.  ', '#  ', '#  ', '#  '], # 2
  ['#  ', 'w  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', 'P  ', '#  '], # 3
  ['#  ', 'g  ', '.  ', '.  ', '.  ', '.  ', '#  ', '#  ', 'G  ', '#  '], # 4
  ['#  ', '#  ', '#  ', '#  ', '#  ', '.  ', '#  ', '#  ', '#  ', '#  '], # 5
  ['#  ', 'P  ', '.  ', '.  ', 'g  ', '.  ', 'g  ', '.  ', '.  ', '#  '], # 6
  ['#  ', '#  ', '#  ', '#  ', '.  ', '#  ', '#  ', '#  ', '#  ', '#  '],
  ['#  ', '.  ', '.  ', 'T  ', '.  ', '.  ', '.  ', '.  ', 'A  ', '#  '],
  ['#  ', '.  ', '#  ', '#  ', '.  ', '#  ', '#  ', '#  ', '.  ', '#  '],
  ['#  ', '.  ', '#  ', 'b  ', '.  ', 'b  ', '.  ', '.  ', '.  ', '#  '],
  ['#  ', '.  ', '#  ', '.  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  '],
  ['#  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '#  '],
  ['#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '.  ', '#  '],
  ['#  ', 'g  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '#  '],
  ['#  ', '.  ', '#  ', '#  ', '.  ', '.  ', '#  ', '#  ', '.  ', '#  '],
  ['#  ', '.  ', '#  ', '#  ', '.  ', '.  ', '#  ', '#  ', '.  ', '#  '],
  ['#  ', '.  ', '.  ', 'g  ', '.  ', '.  ', 'g  ', '.  ', '.  ', '#  '],
  ['#  ', 'B  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', '.  ', 'E  '],
  ['#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ', '#  ']
]   #  0,     1,     2,     3,     4,     5,     6,     7,    8,     9,


"""
print(has_line_of_sight(1, 4, 1, 1, board_1))  # True
print(has_line_of_sight(1, 4, 3, 5, board_1))  # False
print(has_line_of_sight(1, 4, 3, 6, board_1))  # True
print(has_line_of_sight(1, 4, 3, 7, board_1))  # True
print(has_line_of_sight(1, 4, 3, 8, board_1))  # False
print(has_line_of_sight(1, 4, 6, 7, board_1))  # False


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

"""

##### Core Board Utilities #####

# Need to implement valid_move concomittantly 
def get_player_move():
    """Gets player input validates it; returns move"""
    # Moves: "Up", "Down", "Right", "Left", Throw Javelin"
    valid_moves = ["U", "D", "R", "L", "J"]

    while True:      
      move = input("Enter your move (options: " + ", ".join(valid_moves) + "): ").upper()
      if move in valid_moves:
        # check for validity of the move and ask for the input again if its invalid move
        print("You entered:", move)
        if move == "J":
            # Javelin throw logic (replace with full implementation)
            # Check if the npc is in the line-of-sight and then use
            print("Javelin throw not yet implemented! Try again.")
            return "IDLE"
        
        return move
      else:
        print("Invalid instruction. Please try again.")

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
       
def map_board(board):
    """
    Funtion to map board objects/characters to respective class objects with indices and location.
    Objects Created:
    npc_order: list -> created in order top-left -> bottom-right
    object_dict: dict ->  available objects with indices
    monster_dict: dict -> available monsters with indices
    self.player: obj, self.javelin: obj -> instantiated.
    self.exit: obj -> assigned coordinates of exit.
    """
    object_dict = {}
    monster_dict = {}
    pot_idx, treas_idx, portal_idx, trap_idx = 1, 1, 1, 1
    blob_idx, gob_idx, wiz_idx, ogre_idx, minot_idx = 1, 1, 1, 1, 1
    
    """
    The NPCs move in turn according to their original position on the map, starting from the top left 
    corner and moving row-wise left-to-right until the bottom right corner is reached. This initial 
    move sequence is retained even if NPCs later move to other locations. 
    """
    npc_order = []

    for row in range(len(board)):
      for col in range(len(board[row])):
        cell = board[row][col]

        #### Objects
        if cell == "@+J":
          # Instantiate Player and his Javelin
          monster_dict["Hero"] = Hero(name="Hero", hp=PLAYER_HP, damage=1, x=row, y=col)
          object_dict["Javelin"] = javelin(row, col, value=1)
        
        elif cell == POTION:
          object_dict["Potion" + str(pot_idx)] = potion("Potion", row, col, value=1, index=pot_idx)
          pot_idx += 1
        elif cell == TREASURE:
          # Not sure how much value to increase treasure; assume 1
          object_dict["Treasure" + str(treas_idx)] = treasure("Treasure", row, col, value=1, index=treas_idx)
          treas_idx += 1
        elif cell == PORTAL_A or cell == PORTAL_B:
          object_dict["Portal" + str(portal_idx)] = portal("Portal", row, col, index=portal_idx)
          portal_idx += 1
        elif cell == TRAP:
          object_dict["Trap" + str(trap_idx)] = trap("Trap", row, col, value=1, index=trap_idx)
          trap_idx += 1
        
        ##### Monsters
        elif cell == GOBLIN:
          monster_dict["Goblin" + str(gob_idx)] = goblin("Goblin", x=row, y=col, hp=GOBLIN_HP, 
                                                         damage=GOBLIN_DAMAGE, index=gob_idx)
          npc_order.append("Goblin" + str(gob_idx))
          gob_idx += 1
        elif cell == WIZARD:
          monster_dict["Wizard" + str(wiz_idx)] = wizard("Wizard", x=row, y=col, hp=WIZARD_HP,
                                                         damage=WIZARD_DAMAGE,index=wiz_idx)
          npc_order.append("Wizard" + str(wiz_idx))
          wiz_idx += 1
        elif cell == BLOB:
          monster_dict["Blob" + str(blob_idx)] = blob("Blob", x=row, y=col, level=1,
                                                      hp=BLOB_LEVELS[1][0], damage=BLOB_LEVELS[1][1],
                                                      index=blob_idx)
          npc_order.append("Blob" + str(blob_idx))
          blob_idx += 1
        elif cell == OGRE:
          monster_dict["Ogre" + str(ogre_idx)] = ogre("Ogre", x=row, y=col, hp=OGRE_HP, 
                                                      damage=OGRE_DAMAGE, index=ogre_idx)
          npc_order.append("Ogre" + str(ogre_idx))
          ogre_idx += 1
        elif cell == MINOTAUR:
          monster_dict["Minotaur" + str(minot_idx)] = minotaur("Minotaur", x=row, y=col, 
                                                               hp=100000, damage=MINOTAUR_DAMAGE,
                                                               index=minot_idx)
          npc_order.append("Minotaur" + str(minot_idx))
          minot_idx += 1

        #Making not of exit
        elif cell == EXIT:
          exit = board_exit("exit", x=row, y=col)

    # Testing     
    """
    print(self.object_dict.keys())
    print(self.monster_dict.keys())
    print(self.npc_order)
    print(self.player)
    print(self.exit)
    """

    return (object_dict, monster_dict, npc_order, exit)

def lookup_index(object_dict, monster_dict, name, x, y) -> int:
    """
    Returns Object/Character index given name, location
    """
    for key in object_dict.keys():
      if name in key:
        if object_dict[key].x == x and object_dict[key].y == y:
          return object_dict[key].index

    for key in monster_dict.keys():
      if name in key:
        if monster_dict[key].x == x and monster_dict[key].y == y:
          return monster_dict[key].index

def parse_tiles(tile):
    """
    Return objects occupying a tile on the board other than the player.
    """
    tile = remove_spaces(tile)
    objs = []
    for code in tile:
      # 
      if code != "+":
        objs.append(BOARD_LOOKUP[code])
        
    return objs

def print_board(board):
    """Prints the current state of the board: 10 by 20 tile grid."""
    for row in board:
      for cell in row:
        print(cell, end=" ")
      print()  # Newline 

def monster_present(obj_list):
    """
    Finds if the tile containes a monster and returns the name. Else "No"
    """
    for obj in obj_list:
       if obj in MONSTER_LIST:
          return obj
    return False

# Tile Convention:
# (Character > Javelin > Item)

def add_player_to(tile, has_javelin):
   pass

def remove_player_from(tile):
   """
   Needed when tile has Trap, Portal B or just the Floor
   Remember Tile Convention
   Possible Tiles: "@  ", "@+J", "@JT", "@JB", "@+T", "@+B"
   """
   occupants = parse_tiles(tile)
   if occupants[-1] == "Trap":
      return TRAP
   elif occupants[-1] == "Portal":
      return PORTAL_B
   elif occupants[-1] == "Javelin" or occupants[-1] == "Hero":
      return FLOOR

def remove_npc_from(tile):
   """
   NPC can be combinations of javelin and items.
   """
   occupants = parse_tiles(tile)
   
   if len(occupants) > 2:
      return REVERSE_BOARD_LOOKUP[occupants[1]] + "+" + REVERSE_BOARD_LOOKUP[occupants[2]]
   elif len(occupants) == 2:
      return CODE_TO_TILE[REVERSE_BOARD_LOOKUP[occupants[-1]]]
   elif len(occupants) == 1 and (occupants[0] in MONSTER_LIST):
      return FLOOR

def add_npc_to_(code, tile):
   """
   Add NPC to tile: possible sizes of tiles -> (2, 1)
   """
   occupants = parse_tiles(tile)
   if len(occupants) == 2:
      return code + REVERSE_BOARD_LOOKUP[occupants[0]] +  REVERSE_BOARD_LOOKUP[occupants[1]]
   elif len(occupants) == 1:
      return code + "+" + REVERSE_BOARD_LOOKUP[occupants[0]]


def remove_spaces(input_string):
    return [char for char in input_string if char != ' ']

### Possible Tiles other than the players(with or w/o javelin)
# 1. Wall (eliminated by validation_move)
# 2. Empty Floor
# 3. Item  (triggers collision from here on down)
# 4. Item + Javelin (After the injured monster vacates)
# 5. Monster Tiles (no movement into tiles with monsters)
# 6. Monster + Item
# 7. Monster + Item + Javelin (exceptional)

#### Possible Player Tiles
# 1. Player on empty Floor
# 2. Player + Javelin
# 3. Player (w/ or w/o Javelin) + Trap/Portal(After popping up in new portal)

### Not Possible Tiles
# 1. Player (w/ or w/o javelin) + Monster
# 2. Multiple Monsters in same tile (expect when Minotaur is knocked out); in that case 
#   make it dissapear for a while.

"""
print(remove_player_from("@  "))
print(remove_player_from("@+B")+"**")
print(remove_player_from("@+T")+"**")
print(remove_player_from("@JT")+"**")
print(remove_player_from("@+J")+"**")
print(remove_player_from("@JB")+"**")
print(remove_spaces(".  "))
print(parse_tiles(".  "))
print(BOARD_LOOKUP["."])
print(parse_tiles("@+J"))
print(parse_tiles("@JB"))
print(parse_tiles("@JT"))
print(remove_npc_from("g+T"))
print(remove_npc_from("wJP"))
print(remove_npc_from("b  "))
print(remove_npc_from("o+J"))
"""

#(test_object_dict, test_char_dict, test_npc_order, test_exit) = map_board(board_1)

def collide_treasure(new_x, new_y, mov_name, mov_idx="", col_idx=""):
    """
    Handling collions of Player and Ogres with Treasure:
    When collided with by either the hero or ogres, they are consumed and may not be re-used.
    """
    # Get the moving character and its tile
    print(f"{board_1[8][5]} -> {board_1[8][4]}")
    print("After moving to Treasure---->")
    
    mov_char = test_char_dict[mov_name + mov_idx]
    mov_tile = board_1[mov_char.x][mov_char.y]
    # Get the colliding item
    col_treasure = test_object_dict["Treasure" + col_idx]

    if mov_char.name == "Hero":
      # Player consumes the treasue: remove from item list
      mov_char.treasure += col_treasure.treasure_gain      
      test_object_dict.pop("Treasure" + col_idx)
      
      # Assuming Player hasn't moved into the location already to pick up the javelin
      if not(new_x == mov_char.x and new_y == mov_char.y):
        board_1[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
        # Update Hero, Javelin Location
        test_char_dict['Hero'].update_location(new_x, new_y)
        # Update Javelins Location
        if mov_char.has_javelin:
          board_1[new_x][new_y] = "@+J"
          test_object_dict["Javelin"].update_location(new_x, new_y)
        else:
          board_1[new_x][new_y] = "@  "
      # When player is in the current tile to pick up the javelin.
      else:
        board_1[new_x][new_y] = "@+J"
    
    # Need to complete implementation for Ogre
    elif mov_char.name == "Ogre":
      test_object_dict.pop("Ogre" + str(col_idx))
    
    print(f"{board_1[8][5]} -> {board_1[8][4]}")

def jav_pickup(new_x, new_y, mov_name, mov_idx="", col_idx=""):
    print("Before picking up Javelin---->")
    print(f"{board_1[8][5]} -> {board_1[8][4]}")
    print("After picking up Javelin ---->")
    if mov_name == "Hero":
        mov_char = test_char_dict[mov_name + mov_idx]
        mov_char.has_javelin = True
        mov_tile = board_1[mov_char.x][mov_char.y]
        board_1[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
        occupants = parse_tiles(board_1[new_x][new_y])
        item = ""
        # Update Javelin tile with the player and other items if any
        if "Javelin" in occupants and len(occupants) >= 2:
            item = occupants[-1]
            board_1[new_x][new_y] = "@J" + REVERSE_BOARD_LOOKUP[item]
        else:
            board_1[new_x][new_y] = "@+J"
        
        # Update Player Location
        mov_char.update_location(new_x, new_y)
    


"""print("Test 1 \n")
board_1[1][4] = ".  "
board_1[3][7] = "@+J"
(test_object_dict, test_char_dict, test_npc_order, test_exit) = map_board(board_1)
collide_potion(board_1, 3, 8, "Hero", col_idx="1")
"""

(test_object_dict, test_char_dict, test_npc_order, test_exit) = map_board(board_1)
board_1[1][4] = ".  "
board_1[8][5] = "@+J"
board_1[8][4] = "G  "
#test_char_dict["Hero"].has_javelin = False
test_char_dict["Hero"].update_location(8, 5)
test_object_dict["Javelin"].update_location(8, 5)
#jav_pickup(8, 4, "Hero")
#collide_treasure(8, 4, "Hero", col_idx="1")

["g", "w", "b", "o", "M"]
print(add_npc_to_("g", "T  "))
print(add_npc_to_("w", "J+P"))


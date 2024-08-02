# MiniDungeons 2 - deterministic, turn-based rogue-like game, in which the player takes on the
# role of a hero traversing a dungeon level, with the end goal of reaching the exit. 
# Collision Assumptions: 
# 1. Player and other characters cannot occupy the same tile at the same time.
# 2. Direct Collision occurs along cardinal directions. 
# 3. In-direct collision possible along diagonal tiles if allowed.
# 4. Multiple Mosters can occupy same tile - No. Usually avoid unless collision allowed; if 
#    no possible movement, it remains still.
# 5. Automatic Javelin throw at the closest moster if availed of the choice.

from char_const import *
from char_objs import *
from game_boards import game_board
from utils import *
# get_player_move, move_to_coor, map_board, lookup_index, parse_tiles, print_board
# a_star, has_line_of_sight, calculate_fov

class Board:
  def __init__(self, board=None) -> None:
    # Instantiate Game Board 
    self.board = game_board[0]
    #Maps and creates objects and characters on the map
    (self.object_dict, self.char_dict, self.npc_order, self.exit) = map_board(self.board)
    self.init_lookup()
  
    print_board(self.board)

  def is_valid_move(self, new_x, new_y):
    """Checks if a move is valid based on walls"""
    #Implement if the move is javelin.
    
    return 0 <= new_x < WIDTH and 0 <= new_y < HEIGHT and board[new_y][new_x] != WALL

  # Collide Function Template: 
  # Input: (character_name, character_index) -> Character Location, tile on which it resides
  #        (collision_char_index) -> Collision Character Location
  # Body: 

  def move_player(self, new_x, new_y):
    """
    Valid move of player along cardinal directions.
    new_x -> New x index
    new_y -> New y index
    """
    player = self.char_dict["Hero"]
    new_tile = self.board[new_x][new_y]
    tile_occupants = parse_tiles(new_tile)
    # Check if one of them is a monster
    monster = monster_present(tile_occupants)
    
    if new_tile == FLOOR:
      self.move_to_floor(new_x, new_y, "Hero")
    # Case for collision: Implement case when player collides with other objects
    elif monster:  
      #Trigger Collisions with the ONLY monster without moving from the current tile.
      index = lookup_index(self.object_dict, self.char_dict, monster, new_x, new_y)
      self.COL_FUNC_LOOKUP[monster](new_x, new_y, "Hero", col_idx=str(index))
      # Trigger Collision and move into the new tile with items
    else:
      # Separate calls when javelin mixed with items as both move player
      for name in tile_occupants:

        index = lookup_index(self.object_dict, self.char_dict, name, new_x, new_y)
        # call collision function need to figure out when to call it
        self.COL_FUNC_LOOKUP[name](new_x, new_y, "Hero", col_index=str(index))
            
  
  def move_to_floor(self, new_x, new_y, mov_name, mov_idx="", col_idx=0):
    """
    All characters passed as arguments make a move in this EMPTY floor.
    """
    # Figure out the character moving into the tile
    mov_char = self.char_dict[mov_name + mov_idx]
    # Tile of the moving agent
    mov_tile = self.board[mov_char.x][mov_char.y]
    
    # Character -> Player
    if mov_char.name == "Hero":
      self.board[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
      self.char_dict['Hero'].update_location(new_x, new_y)
      if mov_char.has_javelin:
        self.board[new_x][new_y] = "@+J"
        self.object_dict["Javelin"].update_location(new_x, new_y)
      else:
        self.board[new_x][new_y] = "@  "
    
    # Character -> Monster 
    # Implement as we move NPC
    else:
      pass

  def collide_potion(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    """
    Handling collions of Player and Blob with Potions:
    - Potions are used to increase the HP of the hero by 1, up to the maximum of 10. 
    - When collided with by either the hero or blobs, they are consumed and may not be re-used.
    """
    # Get the moving character and its tile
    mov_char = self.char_dict[mov_name + mov_idx]
    mov_tile = self.board[mov_char.x][mov_char.y]
    # Get the colliding item
    col_potion = self.object_dict["Potion" + str(col_idx)]

    if mov_char.name == "Hero":
      # Change healt of Player
      if mov_char.hp != mov_char.max_hp:
          mov_char.hp += col_potion.potion_gain      
          self.object_dict.pop("Potion" + str(col_idx))
      
      # Assuming Player hasn't moved into the location already to pick up the javelin
      if not(new_x == mov_char.x and new_y == mov_char.y):
        self.board[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
        # Update Hero, Javelin Location
        mov_char.update_location(new_x, new_y)
        # Update Javelins Location
        if mov_char.has_javelin:
          self.board[new_x][new_y] = "@+J"
          self.object_dict["Javelin"].update_location(new_x, new_y)
        else:
          self.board[new_x][new_y] = "@  "
      # Player in current tile to pick up the javelin; Previous tile already updated.
      else:
        self.board[mov_char.x][mov_char.y] = "@+J"

    # Need to complete implementation for Blob
    elif mov_char.name == "Blob":
      # Consume Potion and update blobs location and new tile
      self.object_dict.pop("Potion" + col_idx)
      mov_char.update_location(new_x, new_y)
      self.board[new_x][new_y] = add_npc_to_("b", self.board[new_x][new_y])
      # Update previous tile
      self.board[mov_char.x][mov_char.y] = remove_npc_from(mov_tile) 
      
    
  def collide_treasure(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    """
    Handling collions of Player and Ogres with Treasure:
    When collided with by either the hero or ogres, they are consumed and may not be re-used.
    """
    # Get the moving character and its tile
    mov_char = self.char_dict[mov_name + mov_idx]
    mov_tile = self.board[mov_char.x][mov_char.y]
    # Get the colliding item
    col_treasure = self.object_dict["Treasure" + col_idx]

    if mov_char.name == "Hero":
      # Player consumes the treasue: remove from item list
      mov_char.treasure += col_treasure.treasure_gain      
      self.object_dict.pop("Treasure" + col_idx)
      
      # Assuming Player hasn't moved into the location already to pick up the javelin
      if not(new_x == mov_char.x and new_y == mov_char.y):
        self.board[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
        # Update Hero, Javelin Location
        mov_char.update_location(new_x, new_y)
        # Update Javelins Location
        if mov_char.has_javelin:
          self.board[new_x][new_y] = "@+J"
          self.object_dict["Javelin"].update_location(new_x, new_y)
        else:
          self.board[new_x][new_y] = "@  "
      # When player is in the current tile to pick up the javelin.
      else:
        self.board[new_x][new_y] = "@+J"

    # Consume Treasure and move Orgre
    elif mov_char.name == "Ogre":
      # Consume Treasure and update Ogres location and new tile
      self.object_dict.pop("Treasure" + col_idx)
      mov_char.update_location(new_x, new_y)
      self.board[new_x][new_y] = add_npc_to_("o", self.board[new_x][new_y])
      # Update previous tile
      self.board[mov_char.x][mov_char.y] = remove_npc_from(mov_tile) 

  def collide_portal(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    pass

  def collide_trap(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    """
    # Traps deal 1 damage to any game character moving through them, every time.
    """
    # Get the moving character and its tile
    mov_char = self.char_dict[mov_name + mov_idx]
    mov_tile = self.board[mov_char.x][mov_char.y]
    # Get the colliding item
    col_trap = self.object_dict["Trap" + col_idx]

    if mov_char.name == "Hero":
      # Decrease Health of player
      mov_char.hp -= 1
  
      # Assuming Player hasn't moved into the location already to pick up the javelin
      if not(new_x == mov_char.x and new_y == mov_char.y):
        self.board[mov_char.x][mov_char.y] = remove_player_from(mov_tile) 
        # Update Hero, Javelin Location
        mov_char.update_location(new_x, new_y)
        # Update Javelins Location
        if mov_char.has_javelin:
          self.board[new_x][new_y] = "@JT"
          self.object_dict["Javelin"].update_location(new_x, new_y)
        else:
          self.board[new_x][new_y] = "@+T"
      # When player is in the current tile to pick up the javelin.
      else:
        self.board[new_x][new_y] = "@JT"
    
    # All NPC would be affected from a trap
    else:
      mov_char.hp -= 1
      # If NPC is deap, remove from list
      if mov_char.hp <= 0:
        self.char_dict.pop(mov_char.name + mov_idx)
      
      # NEEDS update!!
      # Consume Treasure and update Ogres location and new tile
      self.object_dict.pop("Treasure" + col_idx)
      mov_char.update_location(new_x, new_y)
      self.board[new_x][new_y] = add_npc_to_(REVERSE_BOARD_LOOKUP[mov_char.name], 
                                             self.board[new_x][new_y])
      # Update previous tile
      self.board[mov_char.x][mov_char.y] = remove_npc_from(mov_tile) 

  def collide_exit(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    pass

  def jav_pickup(self, new_x, new_y, mov_name, mov_idx="", col_idx=""):
    # Only player allow to pick up the javelin
    if mov_name == "Hero":
        self.player.has_javelin = True
        mov_tile = self.board[self.player.x][self.player.y]
        self.board[self.player.x][self.player.y] = remove_player_from(mov_tile) 
        occupants = parse_tiles(self.board[new_x][new_y])
        item = ""
        # Update Javelin tile with the player and other items if any
        if "Javelin" in occupants and len(occupants) >= 2:
            item = occupants[-1]
            self.board[new_x][new_y] = "@J" + REVERSE_BOARD_LOOKUP[item]
        else:
            self.board[new_x][new_y] = "@+J"
        
        # Update Player Location
        self.player.update_location(new_x, new_y)

  # Have to split this method into functions
  def handle_collision_player(self, mov_char, col_object):
    """
    Player -> Object/Monster Collision
    """
    # Moving Character = Player/Hero
    if mov_char.name == "Hero":
      if col_object == PORTAL_A:
        # Portals come in pairs. If the hero collides with a portal, they are immediately (on the same
        #  turn) transported to the other paired portal.
        print("Entered portal!")

      # NPC collisions (goblins, wizards, blobs, ogres, minotaurs)
      elif col_object == 'Goblins':
        #  They have 1 HP and deal 1 damage upon collision.
        print("Goblins!")
      elif col_object == 'Wizards':
        # Goblin Wizards (or Ranged Goblins) cast a spell at the hero if they have an unbroken line of 
        # sight within 5 tiles of the player that does 1 damage.
        # Wizards have 1 HP and deal no damage on collision.
        print("Wizards!")
      elif col_object == 'Blobs':
        #  A blob colliding with a potion consumes it. Blobs colliding with  other blobs merge into a 
        # more powerful blob. The lowest level blob has 1 HP and does 1 damage upon collision. The 2nd 
        # level blob has 2 HP and does 2 damage. The most powerful blob has 3 HP and does 3 damage.
        print("Blobs!")
      elif col_object == 'Ogres':
        print("Ogres!")
      elif col_object == 'Minotaurs':
          print("Minotaurs!")

  """
  Goblin
  Wizard
  Ogre
  Blob
  Minotaur
  """

  def move_npc(board, x, y, npc_type):
    """
    Game character may move in one of the four cardinal directions (N, S, E, W) that is not a wall. 
    """
    new_x, new_y = x, y
    # Movement logic for different NPCs (goblins, wizards, blobs, ogres, minotaurs)
    
    # Goblins
    """
    Goblins move 1 tile every turn towards the player if they have an unbroken line of sight to the 
    player. Goblins avoid colliding with other goblins and wizards.
    """
    # Wizards
    """
    If they are over 5 tiles from the player but have line of sight, they will move 1 tile towards 
    the player. 
    """
    #Blobs
    """
    Blobs do not move unless they have unbroken line of sight with either a potion or the hero. If 
    they see either one, they will move 1 tile towards the closest one per turn, preferring potions 
    over the hero in case of a tie.
    """
    #Ogres
    """
    Ogres also do not move unless they have unbroken line of sight with either a treasure or the hero. 
    If they see either one, they will move 1 tile towards the closest per turn, preferring treasures 
    over the hero in case of a tie. When an ogre collides with a treasure, they consume it, and their 
    sprite becomes fancier to look at. Ogres have 2 HP and deal 2 damage to anything they collide 
    with, including other ogres.
    """
    #Minotaurs
    """
    Always moves 1 step along the shortest path to the hero as determined by A* search, regardless of 
    line of sight. Collision with the minitaur will deal 1 damage. A minitaur has no HP and is 
    incapable of dying. If damage is done to it, the minitaur will be knocked out for 3 rounds 
    (and can be passed through).
    """
    return new_x, new_y

  def is_game_over(self):
    """
    Checks if the player has died or the player must reach the exit
    """
    return self.player.hp <= 0 or (self.player.x == self.exit.x and self.player.y == self.exit.y)
  
  def init_lookup(self):
    self.COL_FUNC_LOOKUP = {"Potion":self.collide_potion, "Treasure":self.collide_treasure, 
                            "Portal": self.collide_portal, "Trap":self.collide_trap, 
                            "Exit": self.collide_exit, "Javelin":self.jav_pickup, 
                            "Goblin": self.collide_goblin, "Wizard":self.collide_wizard, 
                            "Blob": self.collide_blob, "Ogre": self.collide_ogre, 
                            "Minotaur": self.collide_minotaur}
        
  
  

  def collide_goblin(self, mov_char, trap_idx):
    pass

  def collide_wizard(self, mov_char, trap_idx):
    pass

  def collide_blob(self, mov_char, trap_idx):
    pass
  
  def collide_ogre(self, mov_char, trap_idx):
    pass

  def collide_minotaur(self, mov_char, trap_idx):
    pass
  
"""
def main():
    #Player gets the first move every turn, and all NPCs move after. 
    
    board = []

    return board
"""

# main driver
if __name__ == '__main__':
    # create board instance
    board = Board()
    
    # start game loop
    #board.game_loop()

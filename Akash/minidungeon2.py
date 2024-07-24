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

  def move_to_floor(self, cur_tile, char_name, char_idx=0):
    character = self.char_dict[char_name]
    (new_x, new_y) = (character.x, character.y)
    new_tile = self.board[new_x][new_y]
    # Case for empty floor
    if new_tile == FLOOR:
      if character.name == "Hero":
        pass
      else:
        pass
    # Case for non-empty floor
    else:
      pass


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
    cur_tile = self.board[player.x][player.y]
    cur_tile_wo_player = remove_player_from(cur_tile) # with the player removed
    # Case when player has javelin: next tiles could be objects/characters or a combination of them
    if player.has_javelin:

      # Case for moving to an empty floor tile 
      if new_tile == FLOOR:
        # switch floor tile with player along with his javelin
        self.board[new_x][new_y] == "@+J"
        self.board[player.x][player.y] = cur_tile_wo_player
        self.javelin.update_location(new_x, new_y)

      # Case for collision: Implement case when player collides with other objects
      else:
        #Trigger Collisions with the ONLY monster without moving from the current tile.
        if monster:
          index = lookup_index(self.object_dict, self.monster_dict, monster, new_x, new_y)
          # call collision function for monsters which won't move the player
          self.COL_FUNC_LOOKUP[monster]("Hero", col_idx=index)
        # Trigger Collision and move into the new tile w/o Monster
        else:
          # Since the player has javelin; only possible tiles are with items/objects
          for name in tile_occupants:
            index = lookup_index(self.object_dict, self.monster_dict, name, new_x, new_y)
            # call collision function need to figure out when to call it
            self.COL_FUNC_LOOKUP[name]("Hero", index)
            #update player and javelin location to be updated in the lookup function
            #self.board[new_x][new_y] == "@+J"
            #self.board[self.player.x][self.player.y] = cur_tile_wo_player
            #self.javelin.update_location(new_x, new_y)

    # Case when player does not have javelin: new tiles could be mixed with Javelin
    else:
      # Empty Floor Tile
      if new_tile == FLOOR:
        # swith floor tile with player w/o javelin with floor tile
        self.board[new_x][new_y] == "@  "
        self.board[self.player.x][self.player.y] = cur_tile_wo_player
      # Floor tile has Javelin and player acquires it by moving onto it.
      elif new_tile == ".+J":
        self.player.has_javelin = True
        self.board[new_x][new_y] == "@+J"
        self.board[self.player.x][self.player.y] = cur_tile_wo_player
        
      # Collision with objects or monsters: case with just objects and objects+javelin.
      else:
        if monster:
          index = lookup_index(self.object_dict, self.monster_dict, monster, new_x, new_y)
          self.COL_FUNC_LOOKUP[monster](self.player, index)
        else:
          for name in tile_occupants:
            index = lookup_index(self.object_dict, self.monster_dict, name, new_x, new_y)
            self.COL_FUNC_LOOKUP[name](self.player, index)
            #update player and javelin location
            self.board[new_x][new_y] == "@+J"
            self.board[self.player.x][self.player.y] = cur_tile_wo_player
            
  
  """
  Goblin
  Wizard
  Ogre
  Blob
  Minotaur
  """

  def collide_potion(self, mov_char, mov_idx=0, col_idx=0):
    """
    Handling collions of Player and Blob with Potions:
    - Potions are used to increase the HP of the hero by 1, up to the maximum of 10. 
    - When collided with by either the hero or blobs, they are consumed and may not be re-used.
    """
    col_potion = self.object_dict["Potion" + str(col_idx)]
    (new_x, new_y) = (col_potion.x, col_potion.y)

    #self.board[new_x][new_y] == "@+J"
    #self.board[self.player.x][self.player.y] = cur_tile_wo_player
    #self.javelin.update_location(new_x, new_y)
    # Moving Character = Player/Hero
    if mov_char == "Hero":
      player = self.char_dict["Hero"]
      cur_tile = self.board[player.x][player.y]
      if player.hp != player.max_hp:
          player.hp += col_potion.potion_gain
          # Remove after testing
          print(f"Player found a potion! at ({col_potion.x}, {col_potion.y})")
          self.object_dict.pop("Potion" + str(col_idx))
          print(f"Potion Consumed!")
    elif mov_char == "Blob":
      print(f"Blob found a potion! at ({col_potion.x}, {col_potion.y})")
      self.object_dict.pop("Potion" + str(col_idx))
      print(f"Potion Consumed!")
    
  def collide_treasure(self, mov_char, mov_idx=0, col_idx=0):
    """
    Handling collions of Player and Ogres with Treasure:
    When collided with by either the hero or ogres, they are consumed and may not be re-used.
    """
    col_treasure = self.object_dict["Potion" + str(col_idx)]
    if mov_char == "Hero":
      self.player.treasure += col_treasure.treasure_gain
      print(f"Player found a Treasure! at ({col_treasure.x}, {col_treasure.y})")
      self.object_dict.pop("Treasure" + str(col_idx))
      print(f"Treasure Consumed!")
    elif mov_char == "ogre":
      print(f"Ogre found a Treasure! at ({col_treasure.x}, {col_treasure.y})")
      self.object_dict.pop("Treasure" + str(col_idx))
      print(f"Ogre consumed Treasure!")

  # Have to split this method into functions
  def handle_collision_player(self, mov_char, col_object):
    """
    Player -> Object/Monster Collision
    """
    # Moving Character = Player/Hero
    if mov_char.name == "Hero":
      if col_object.name == "treasure":
        # Treasures are used to increase the treasure score of the hero. 
        # When collided with by either the hero or ogres, they are consumed and may not be re-used.
        print("Found a treasure!")

      elif col_object == PORTAL_A:
        # Portals come in pairs. If the hero collides with a portal, they are immediately (on the same
        #  turn) transported to the other paired portal.
        print("Entered portal!")

      elif col_object == TRAP:
        # Traps deal 1 damage to any game character moving through them, every time.
        print("Stepped on a trap!")
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
        
  def collide_portal(self, mov_char, portal_idx):
    pass

  def collide_trap(self, mov_char, trap_idx):
    pass

  def collide_exit(self, mov_char, exit_idx):
    pass

  def jav_pickup(self, mov_char, trap_idx):
    # Implement javelin pickup
    self.player.has_javelin = True
    #self.board[new_x][new_y] == "@+J"
    #self.board[self.player.x][self.player.y] = cur_tile_wo_player

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

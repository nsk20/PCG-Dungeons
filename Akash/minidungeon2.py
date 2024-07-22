# MiniDungeons 2 - deterministic, turn-based rogue-like game, in which the player takes on the
# role of a hero traversing a dungeon level, with the end goal of reaching the exit. 

from char_const import *
from char_objs import *
from game_boards import game_board
from utils import has_line_of_sight, a_star, move_to_coor

class Board:
  def __init__(self, board=None) -> None:
    # Instantiate Game Board 
    self.board = game_board[0]
    Hero()
    self.print_board()

  def print_board(self):
    """Prints the current state of the board: 10 by 20 tile grid."""
    for row in self.board:
      for cell in row:
        print(cell, end=" ")
      print()  # Newline 

  def get_player_move():
    """Gets player input validates it; returns move"""

    valid_moves = {"U", "D", "R", "L", "J"}  

    while True:      
      move = input("Enter your move (options: " + ", ".join(valid_moves) + "): ").upper()
      if move in valid_moves:
        print("You entered:", move)
        return move
      elif move == "J":
        # Javelin throw logic (replace with full implementation)
        print("Javelin throw not yet implemented! Try again.")
        return "IDLE"
      else:
        print("Invalid instruction. Please try again.")

  def is_valid_move(self, del_x, del_y):
    """Checks if a move is valid based on walls"""

    #del_x, del_y = move_to_coor(move)
    if del_x != 20 and del_y != 20:
      new_x = Hero.x + del_x
      new_y = Hero.y + del_y
    else:
       pass # implement Javeline throw
    
    return 0 <= new_x < WIDTH and 0 <= new_y < HEIGHT and board[new_y][new_x] != WALL

  def move_player(self, x, y, direction):
    """
    """
    if self.is_valid_move(self.board, x, y, direction):
      board[y][x] = FLOOR
      new_x, new_y = x, y
      if direction == "W":
        new_y -= 1
      elif direction == "A":
        new_x -= 1
      elif direction == "S":
        new_y += 1
      elif direction == "D":
        new_x += 1
      board[new_y][new_x] = PLAYER
    return new_x, new_y

  def handle_collision(board, x, y, character):
    """
    Map contains many different objects the player can collide with.
    """
    if character == POTION:
      # Potions are used to increase the HP of the hero by 1, up to the maximum of 10. 
      # When collided with by either the hero or blobs, they are consumed and may not be re-used.
      print("Found a potion!")
    elif character == TREASURE:
      # Treasures are used to increase the treasure score of the hero. 
      # When collided with by either the hero or ogres, they are consumed and may not be re-used.
      print("Found a treasure!")
    elif character == PORTAL_A:
      # Portals come in pairs. If the hero collides with a portal, they are immediately (on the same
      #  turn) transported to the other paired portal.
      print("Entered portal!")
    elif character == TRAP:
      # Traps deal 1 damage to any game character moving through them, every time.
      print("Stepped on a trap!")
    # NPC collisions (goblins, wizards, blobs, ogres, minotaurs)
    elif character == 'Goblins':
      #  They have 1 HP and deal 1 damage upon collision.
      print("Goblins!")
    elif character == 'Wizards':
      # Goblin Wizards (or Ranged Goblins) cast a spell at the hero if they have an unbroken line of 
      # sight within 5 tiles of the player that does 1 damage.
      # Wizards have 1 HP and deal no damage on collision.
      print("Wizards!")
    elif character == 'Blobs':
      #  A blob colliding with a potion consumes it. Blobs colliding with  other blobs merge into a 
      # more powerful blob. The lowest level blob has 1 HP and does 1 damage upon collision. The 2nd 
      # level blob has 2 HP and does 2 damage. The most powerful blob has 3 HP and does 3 damage.
      print("Blobs!")
    elif character == 'Ogres':
      print("Ogres!")
    elif character == 'Minotaurs':
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
    If they are over 5 tiles from the player  but have line of sight, they will move 1 tile towards 
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

  def is_game_over(player_hp):
    """Checks if the player has died or
      To win, the player must reach the exit
      """
    return player_hp <= 0

  def get_initial_move_sequence(self) -> list:
    """
    The NPCs move in turn according to their original position on the map, starting from the top left 
    corner and moving row-wise left-to-right until the bottom right corner is reached. This initial 
    move sequence is retained even if NPCs later move to other locations. 
    """
    return []
  

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

# Constants
WIDTH = 10
HEIGHT = 20
PLAYER_HP = 10 # All characters have Hit Points (HP) and may deal damage; player starts with 10 HP.
JAVELIN_DAMAGE = 1
POTION_HEAL = 1
GOBLIN_HP = 1
GOBLIN_WIZARD_HP = 1
BLOB_LEVELS = {1: (1, 1), 2: (2, 2), 3: (3, 3)}  # HP, Damage
OGRE_HP = 2
OGRE_DAMAGE = 2
MINOTAUR_DAMAGE = 1

# Tile types: Each tile is either an impassible wall or a passable floor.
WALL = "#"   
FLOOR = "." # may contain hero, NPCs, gameplay objects or nothing at all.

# Gameplay Objects: treasures, potions, portals, traps, and the exit of the level.
POTION = "P"
TREASURE = "G"
PORTAL_A = "A" 
PORTAL_B = "B" 
TRAP = "T" 
EXIT = "E"
PLAYER = "@"
# Monsters: some of which have secondary goals in addition to attacking the player.
GOBLIN = "g"
GOBLIN_WIZARD = "w"
BLOB = "b"
OGRE = "o"     
MINOTAUR = "M" 
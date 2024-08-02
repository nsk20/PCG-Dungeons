# Constants
# Tile types: Each tile is either an impassible wall or a passable floor.
WIDTH = 10
HEIGHT = 20
WALL = "#  "   
FLOOR = ".  " # may contain hero, NPCs, gameplay objects or nothing at all.

#Player and Javelin
PLAYER = "@  "
PLAYER_HP = 10 # All characters have Hit Points (HP) and may deal damage; player starts with 10 HP.
JAVELIN = "J  "
JAVELIN_DAMAGE = 1

# Gameplay Objects: treasures, potions, portals, traps, and the exit of the level.
POTION = "P  " # Multiple Potions
POTION_HEAL = 1

TREASURE = "G  " # Multiple treasures
PORTAL_A = "A  " # Only one A Portal; only one pair of portals per level.
PORTAL_B = "B  " # Only one B portal
TRAP = "T  " # Multiple Traps
EXIT = "E  " # Only one exit

# Monsters: some of which have secondary goals in addition to attacking the player.
# Inherinting for a parent character class as a monster class.
GOBLIN = "g  "
GOBLIN_HP = 1
GOBLIN_DAMAGE = 1
WIZARD = "w  "
WIZARD_HP = 1
WIZARD_DAMAGE = 1
BLOB = "b  "
BLOB_LEVELS = {1: (1, 1), 2: (2, 2), 3: (3, 3)}  # HP, Damage
OGRE = "o  "    
OGRE_HP = 2
OGRE_DAMAGE = 2 
MINOTAUR = "M  " 
MINOTAUR_DAMAGE = 1

BOARD_LOOKUP = {"P":"Potion", "G":"Treasure", "A":"Portal", "B":"Portal", "T":"Trap", "E":"Exit", 
                "J": "Javelin", "g": "Goblin", "w":"Wizard", "b":"Blob", "o":"Ogre", "M":"Minotaur",
                "@": "Hero", ".": "Floor"}

REVERSE_BOARD_LOOKUP = {"Potion":"P", "Treasure":"G", "Portal":"A", "Portal":"B", "Trap":"T", 
                        "Exit":"E", "Javelin":"J", "Goblin":"g", "Wizard":"w", "Blob":"b", "Ogre":"o",
                        "Minotaur":"M", "Hero":"@", "Floor":"."}

MONSTER_LIST = ["Goblin", "Wizard", "Blob", "Ogre", "Minotaur"]
OBJECT_LIST = ["Potion", "Treasure", "Portal", "Trap", "Exit", "Javelin"]
MONSTER_CODE = ["g", "w", "b", "o", "M"]
OBJECT_CODE = ["P", "G", "A", "B", "T", "E"]
CODE_TO_TILE = {"P": POTION, "G": TREASURE, "A":PORTAL_A, "B":PORTAL_B, "T":TRAP, "E":EXIT,
                "g": GOBLIN, "w":WIZARD, "b":BLOB, "o":OGRE, "M":MINOTAUR, ".":FLOOR, "J":JAVELIN,
                "@":PLAYER}
class Character:
    def __init__(self, name, hp, damage, x, y):
        """
        name -> Name of the character
        hp -> Current Health Points
        damage -> Damage the character can do
        char_type -> Charater Type: Player, Monster
        """
        self.name = name
        self.hp = hp
        self.max_hp = hp
        self.damage = damage
        self.x = x
        self.y = y
    
    def __str__(self) -> str:
        return f"Name: {self.name} \nLocation: ({self.x}, {self.y} \nHP: {self.hp})"
    
    def update_location(self, new_x, new_y):
        self.x = new_x
        self.y = new_y
        


class Hero(Character):
    """The player is given one re-usable javelin at the start of every level. The player may choose to 
    throw this javelin and do 1 damage to any monster within their unbroken line of sight. After using 
    the javelin, the hero must traverse to the tile to which it was thrown in order to pick it up and 
    use it again. 
    """

    def __init__(self, name, hp, damage, x, y):
        super().__init__(name, hp, damage, x, y)
        self.treasure = 0
        self.has_javelin = True

    def throw_javelin(self, game):
        # Implementation for javelin throwing
        pass
    def __str__(self) -> str:
        return super().__str__() + f"\nTreasure = {self.treasure} \nHas Javelin = {self.has_javelin}"


"""
class Monster(Character):
    def __init__(self, name, hp, damage):
        super().__init__(name, hp, damage)

    def take_turn(self, game):
        # Generic monster turn, to be overridden by specific monsters
        pass
GOBLIN_HP = 1
GOBLIN_WIZARD_HP = 1
BLOB_LEVELS = {1: (1, 1), 2: (2, 2), 3: (3, 3)}  # HP, Damage
OGRE_HP = 2
OGRE_DAMAGE = 2
MINOTAUR_DAMAGE = 1
"""
class goblin(Character):
    def __init__(self, name, x, y, hp, damage, index):
        super().__init__(name, hp, damage, x, y)
        self.index = index

class wizard(Character):
    def __init__(self, name, x, y, hp, damage, index):
        super().__init__(name, hp, damage, x, y)
        self.index = index

class ogre(Character):
    def __init__(self, name, x, y, hp, damage, index):
        super().__init__(name, hp, damage, x, y)
        self.index = index

class blob(Character):
    def __init__(self, name, x, y, hp, damage, index, level):
        super().__init__(name, hp, damage, x, y)
        self.level = level
        self.index = index

class minotaur(Character):
    def __init__(self, name, x, y, hp, damage, index):
        super().__init__(name, hp, damage, x, y)
        self.index = index


##### Modeling Gameplay Objects: Potion, Treasure and Traps, Portals and an Exit and Javelin #####
class gameplay_objects:
    def __init__(self, name, x, y, index = 0) -> None:
        """
        (x, y): Matrix index of current location
        index -> i.d # of the object. Default = 0 means there is an unique object.
        """
        self.name = name
        self.index = index
        # Location
        self.x = x
        self.y = y

    def __str__(self) -> str:
        return f"Name: {self.name} \nLocation: ({self.x}, {self.y})"

class potion(gameplay_objects):
    def __init__(self, name, x, y, value, index=0) -> None:
        super().__init__(name, x, y, index)
        self.potion_gain = value

class treasure(gameplay_objects):
    """
    Modeling multiple treasures numbered by index
    """
    def __init__(self, name, x, y, value, index=0) -> None:
        super().__init__(name, x, y, index)
        self.treasure_gain = value

class portal(gameplay_objects):
    """
    Modeling only two portals: A and B
    """
    def __init__(self, name, x, y, index=0) -> None:
        super().__init__(name, x, y, index)


class trap(gameplay_objects):
    """
    value -> damage caused by trap
    """
    def __init__(self, name, x, y, value, index=0) -> None:
        super().__init__(name, x, y, index)
        self.trap_loss = value

class javelin(gameplay_objects):
    """
    value -> damage caused by javelin
    """
    def __init__(self, x, y, value, index=0) -> None:
        super().__init__("javelin", x, y, index)
        self.damage = value
    
    def update_location(self, x, y):
        self.x = x
        self.y = y
    
class board_exit(gameplay_objects):
    def __init__(self, name, x, y, index=0) -> None:
        super().__init__(name, x, y, index)
        
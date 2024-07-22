class Character:
    def __init__(self, name, hp, damage):
        self.name = name
        self.hp = hp
        self.max_hp = hp
        self.damage = damage
        self.x = 0
        self.y = 0

    def move(self, dx, dy, game):
        new_x = self.x + dx
        new_y = self.y + dy
        if 0 <= new_x < game.width and 0 <= new_y < game.height:
            if game.map[new_y][new_x].type != 'wall':
                self.x = new_x
                self.y = new_y
                return True
        return False

class Hero(Character):
    def __init__(self):
        super().__init__("Hero", 10, 1)
        self.treasure = 0
        self.has_javelin = True

    """The player is given one re-usable javelin at the start of every level. The player may choose to 
    throw this javelin and do 1 damage to any monster within their unbroken line of sight. After using 
    the javelin, the hero must traverse to the tile to which it was thrown in order to pick it up and 
    use it again. 
    Q1 - Can two objects occupy the same tile? How should that be modelled?
    Q2 - 
    """
    def throw_javelin(self, game):
        # Implementation for javelin throwing
        pass

class Monster(Character):
    def __init__(self, name, hp, damage):
        super().__init__(name, hp, damage)

    def take_turn(self, game):
        # Generic monster turn, to be overridden by specific monsters
        pass
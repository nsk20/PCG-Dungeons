from copy import deepcopy

#### Tic Tac Toe Class

class Board():
    # create constructor 
    def __init__(self, board=None):
        self.player_1 = 'x'
        self.player_2 = 'o'
        self.empty_square ='.'

        #define board position
        self.position = {}

        #init (reset) board
        self.__init_board()

        #create a copy of previous board state if available
        if board is not None:
            self.__dict__ = deepcopy(board.__dict__)

    def __init_board(self):
        #Loop over board rows 
        for row in range(3):
            #Loop over board columns
            for col in range(3):
                #set every board square into empty square
                self.position[row, col] = self.empty_square

    # Make Move Function
    def make_move(self, row, col):
        #create new board instance
        board = Board()

        #make move
        board.position[row, col] = self.player_1

        #swap players
        (board.player_1, board.player_2) = (board.player_2, board.player_1)

        return board
    
    #Get whether game is drawn
    def is_draw(self):
        #loop over board sqaures
        for row, col in self.position:
            #empty square is available
            if self.position[row, col] == self.empty_square:
                return False
        # by default return 
        return True
    
    #Get whether game is win
    def is_win(self):
        ##############################
        ## vertical sequence detection
        ##############################
        #loop over board columns
        for col in range(3):
            #define winning list
            winning_sequence = []

            #loop over board rows
            for row in range(3):
                #if 
                if self.position[row, col] == self.player_2:
                    winning_sequence.append((row, col))

                # if we have 3 elements in a row:
                if len(winning_sequence) == 3:
                    #return the game in won state
                    return True

        ##############################
        ## horizontal sequence detection
        ##############################
        #loop over board rows
        for row in range(3):
            #define winning list
            winning_sequence = []

            #loop over board columns
            for col in range(3):
                #if found same next element in the row
                if self.position[row, col] == self.player_2:
                    winning_sequence.append((row, col))

                # if we have 3 elements in a row:
                if len(winning_sequence) == 3:
                    #return the game in won state
                    return True

        ##############################
        ## 1st diagonal sequence detection
        ##############################

        #define winning list
        winning_sequence = []
        #loop over board rows
        for row in range(3):
            #initialise column
            col = row

            #if found same next element in the row
            if self.position[row, col] == self.player_2:
                winning_sequence.append((row, col))
                
            # if we have 3 elements in a row:
            if len(winning_sequence) == 3:
                #return the game in won state
                return True
                

        ##############################
        ## 2nd diagonal sequence detection
        ##############################

        #define winning list
        winning_sequence = []
        #loop over board rows
        for row in range(3):
            #initialise column
            col = 3 - row - 1

            #if found same next element in the row
            if self.position[row, col] == self.player_2:
                winning_sequence.append((row, col))
                
            # if we have 3 elements in a row:
            if len(winning_sequence) == 3:
                #return the game in won state
                return True
                
        
        # By default non win state
        return False
        

    #print board state
    def __str__(self) -> str:
        # define board string representation
        board_string = ''
        for row in range(3):
            #Loop over board columns
            for col in range(3):
                board_string += ' %s ' % self.position[row, col]
            
            #print new line after finishing the row
            board_string += '\n'
        
        # prepend side to move
        if self.player_1 == 'x':
            board_string = '\n-------------\n "x" to move: \n-------------\n \n' + board_string
        elif self.player_1 == 'o':
            board_string = '\n-------------\n "o" to move: \n-------------\n \n' + board_string

        # return board string
        return board_string

#main driver
if __name__ == '__main__':
    board = Board()

    #Define Custom Board State
    board.position = {
        (0, 0): 'x', (0, 1): 'o', (0, 2): 'o', 
        (1, 0): 'o', (1, 1): 'o', (1, 2): 'x', 
        (2, 0): 'o', (2, 1): 'x', (2, 2): 'x',
    }   

    #swap players manually
    board.player_1 = 'x'
    board.player_2 = 'o'

    #print board
    print(board)
    print(f'Player_2: {board.player_2}')
    print('Win Status:', board.is_win())



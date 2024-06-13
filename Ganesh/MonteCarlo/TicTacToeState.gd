class_name TicTacToeState
extends Node

var is_x_turn:bool=true
var board=[['-','-','-'],['-','-','-'],['-','-','-']]

const ex='X'
const oh='O'
const blank='-'

func check_is_terminal():
	if is_x_winner() or is_o_winner() or is_board_full():
		return true
	else:
		return false
func gen_moves():
	if check_is_terminal():
		return []
	var possible_next_moves=[]
	for a in range(board.size()):
		for b in range(board[a].size()):
			if board[a][b]==blank:
				var new_board=TicTacToeState.new()
				new_board.board=board.duplicate(true)
				if is_x_turn:
					new_board.board[a][b]=ex
				else:
					new_board.board[a][b]=oh
				new_board.is_x_turn=is_x_turn!=true
				possible_next_moves.append(new_board)
				continue
	return possible_next_moves
func print_board():
	var output=''
	for a in board:
		for b in a:
			output+=b
		output+='\n'
	if is_x_turn:
		output+=ex
	else:
		output+=oh
	output+=' to play'
	print(output)
func is_x_winner():
	for i in range(board.size()):
		if ex==board[i][0] and ex==board[i][1] and ex==board[i][2]:
			return true
	for i  in range(board[0].size()):
		if ex==board[0][i] and ex==board[1][i] and ex==board[2][i]:
			return true
	if ex==board[0][0] and ex==board[1][1] and ex==board[2][2]:
		return true
	if ex==board[0][2] and ex==board[1][1] and ex==board[2][0]:
		return true
	return false
func is_o_winner():
	for i in range(board.size()):
		if oh==board[i][0] and oh==board[i][1] and oh==board[i][2]:
			return true
	for i  in range(board[0].size()):
		if oh==board[0][i] and oh==board[1][i] and oh==board[2][i]:
			return true
	if oh==board[0][0] and oh==board[1][1] and oh==board[2][2]:
		return true
	if oh==board[0][2] and oh==board[1][1] and oh==board[2][0]:
		return true
	return false
func is_board_full():
	for a in board:
		for b in a:
			if b==blank:
				return false
	return true

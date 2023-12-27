require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

board = Board.new
player1 = Player.new('Alice', 'X')
player2 = Player.new('Bob', 'O')
game = Game.new(player1, player2, board)

game.play

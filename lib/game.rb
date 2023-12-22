require_relative '../lib/player'
require_relative '../lib/board'

class Game
  attr_reader :player1, :player2, :board, :current_player

  def initialize(player1, player2, board)
    @player1 = player1
    @player2 = player2
    @board = board
    setup_game
  end

  def setup_game
    @current_player = @player1
    @board.reset_board
  end
end

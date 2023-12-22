require_relative '../lib/player'
require_relative '../lib/board'

class Game
  attr_reader :player1, :player2, :board, :current_player

  def initialize(player1, player2, board)
    @player1 = player1
    @player2 = player2
    @board = board
  end

  def setup_game
    @current_player = @player1
    @board.reset_board
  end

  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def get_player_input
    loop do
      user_input = gets.chomp
      verified_number = verify_input(user_input.to_i) if user_input.match?(/^\d+$/)
      return verified_number if verified_number

      puts "Input error! Please enter a number between #{min} or #{max}."
    end
  end

  def verify_input(input)
    return input if input.between?(0, 5)
  end
end

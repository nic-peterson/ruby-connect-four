require_relative '../lib/player'
require_relative '../lib/board'

class Game
  attr_reader :player1, :player2, :board, :current_player, :min, :max

  def initialize(player1, player2, board)
    @player1 = player1
    @player2 = player2
    @board = board
    @min = 0
    @max = 5
    @current_player = @player1
  end

  def setup_game
    @current_player = @player1
    @board.reset_board
  end

  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def player_input
    loop do
      user_input = gets.chomp
      verified_number = verify_input(user_input.to_i) if user_input.match?(/^\d+$/)
      return verified_number if verified_number

      puts "Input error! Please enter a number between #{min} or #{max}."
    end
  end

  def verify_input(input)
    return input if input.between?(@min, @max)
  end

  def update_board(column)
    @board.add_piece(column, @current_player.symbol)
  end

  def check_winner
    if @board.winning_combination?(@current_player.symbol)
      @current_player
    else
      nil
    end
  end

  def check_draw
    # Check if board is full and no winning combination
    if @board.is_full?
      # Check if there is a winning combination return false
      if @board.winning_combination?(@player1.symbol) || @board.winning_combination?(@player2.symbol)
        return false
      # If there is no winning combination return true => draw
      else
        return true
      end
    # If board is not full return false, not a draw YET
    else
      return false
    end
  end

  def announce_results
    if check_winner
      puts "#{check_winner.symbol} wins!"
    elsif check_draw
      puts "It's a draw!"
    end
  end

  def game_over?
    if check_winner
      return true
    elsif check_draw
      return true
    else
      return false
    end
  end

  def play
  end
end

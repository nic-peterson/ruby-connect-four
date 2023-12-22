class Board
  attr_reader :board

  def initialize
    @board = create_initial_board
  end

  def create_initial_board
    Array.new(6) { Array.new(7, '.') }
  end

  def draw
    @board.each do |row|
      puts row.join(' ')
    end
  end

  def add_piece(column, symbol)
    # Assuming the bottom row is the first to be filled
    row = @board.reverse.find { |r| r[column] == '.' }
    row[column] = symbol if row
  end

  def reset_board
    @board = create_initial_board
  end

  def winning_combination?
    # true
    # horizontal_win?(symbol) ||
    #  vertical_win?(symbol) ||
    #  diagonal_win?(symbol)
  end
end

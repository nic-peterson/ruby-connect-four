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
    cols = [0, 1, 2, 3, 4, 5, 6]
    puts cols.join(' ')
  end

  def add_piece(column, symbol)
    # Assuming the bottom row is the first to be filled
    row = @board.reverse.find { |r| r[column] == '.' }
    row[column] = symbol if row
  end

  def reset_board
    @board = create_initial_board
  end

  def winning_combination?(symbol)
    # true
    horizontal_win?(symbol) || vertical_win?(symbol) || diagonal_win?(symbol)
  end

  def create_stalemate_board
    @board = Array.new(6) { Array.new(7) }
    7.times do |j|
      6.times do |i|
        @board[i][j] = ((j % 3 == 0 && i.even?) || (j % 3 != 0 && i.odd?)) ? 'X' : 'O'
      end
    end
  end

  private

  def horizontal_win?(symbol)
    @board.any? { |row| four_consecutive?(row, symbol) }
  end

  def vertical_win?(symbol)
    @board.transpose.any? { |col| four_consecutive?(col, symbol) }
  end

  def four_consecutive?(array, symbol)
    array.each_cons(4).any? { |four| four.all? { |cell| cell == symbol } }
  end

  def diagonal_win?(symbol)
    # Check for diagonal wins. This is more complex and requires checking
    # diagonals in both directions.
    diagonals.any? { |diag| four_consecutive?(diag, symbol) }
  end

  def diagonals
    # Get all diagonals from left to right
    left_to_right = []
    (3 - @board.size).upto(@board[0].size - 4) do |offset|
      left_to_right << (0...@board.size).collect { |i| @board[i][i + offset] if i + offset < @board[0].size }.compact
    end

    # Get all diagonals from right to left
    right_to_left = []
    3.upto(@board[0].size + @board.size - 5) do |offset|
      right_to_left << (0...@board.size).collect { |i| @board[i][offset - i] if offset - i < @board[0].size }.compact
    end

    left_to_right + right_to_left
  end
end

board = Board.new
board.create_stalemate_board

board.draw

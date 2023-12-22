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

  def winning_combination?(symbol)
    # true
    horizontal_win?(symbol) || vertical_win?(symbol) ## ||
    #  diagonal_win?(symbol)
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
    [
      (0...@board.size).collect { |i| @board[i][i] },
      (0...@board.size).collect { |i| @board[i][@board.size - i - 1] }
    ]
  end
end

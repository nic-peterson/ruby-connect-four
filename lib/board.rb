class Board
  attr_reader :grid

  def initialize
    @grid = create_initial_board
  end

  def create_initial_board
    Array.new(6) { Array.new(7, '.') }
  end

  def draw
    @grid.each do |row|
      puts row.join(' ')
    end
  end

  def add_piece(column, symbol)
    # Assuming the bottom row is the first to be filled
    row = @grid.reverse.find { |r| r[column] == '.' }
    row[column] = symbol if row
  end
end

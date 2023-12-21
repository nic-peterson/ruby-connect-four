require_relative '../lib/board.rb'

describe Board do
  subject(:game_board) { described_class.new() }

  describe '#create_initial_board' do
    it 'creates a 6x7 board filled with dots' do
      game_board = Board.new
      expect(game_board.grid).to be_a(Array)
      expect(game_board.grid.length).to eq(6) # 6 rows
      game_board.grid.each do |row|
        expect(row).to be_a(Array)
        expect(row.length).to eq(7) # 7 columns
        row.each do |cell|
          expect(cell).to eq('.')
        end
      end
    end
  end

  describe '#draw' do
    context "when the game starts and players see an empty board" do
      it 'prints an board to the console' do
        board = Board.new
        expected_output = <<~BOARD
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
        BOARD
        expect { board.draw }.to output(expected_output).to_stdout
      end
    end
    context 'when player X takes a space with their piece' do
      it 'prints the board with the player X piece' do
        # board = Board.new
        game_board.add_piece(3, 'X') # Assuming 0-based index for columns

        expected_output = <<~BOARD
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . X . . .
        BOARD

        expect { game_board.draw }.to output(expected_output).to_stdout
      end
    end
    context 'when player O takes a space with their piece' do
      it 'prints the board with the player O piece on top of X' do
        # board = Board.new
        game_board.add_piece(3, 'X') # Place X first
        game_board.add_piece(3, 'O') # Then place O

        expected_output = <<~BOARD
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . O . . .
          . . . X . . .
        BOARD

        expect { game_board.draw }.to output(expected_output).to_stdout
      end

      it 'prints the board with the player O piece adjacent to X' do
        # board = Board.new
        game_board.add_piece(3, 'X') # Place X first
        game_board.add_piece(4, 'O') # Then place O

        expected_output = <<~BOARD
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . X O . .
        BOARD

        expect { game_board.draw }.to output(expected_output).to_stdout
      end
    end
  end
end

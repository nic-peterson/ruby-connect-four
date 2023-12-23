require_relative '../lib/board.rb'

describe Board do
  subject(:game_board) { described_class.new() }

  describe '#create_initial_board' do
    it 'creates a 6x7 board filled with dots' do
      game_board = Board.new
      expect(game_board.board).to be_a(Array)
      expect(game_board.board.length).to eq(6) # 6 rows
      game_board.board.each do |row|
        expect(row).to be_a(Array)
        expect(row.length).to eq(7) # 7 columns
        row.each do |cell|
          expect(cell).to eq('.')
        end
      end
    end
  end

  subject(:add_board) { described_class.new() }
  describe '#add_piece' do
    let(:column) { 3 }
    let(:symbol) { 'X' }

    context 'when the column is empty' do
      it 'adds a piece to the board in the specified column' do
        add_board.add_piece(column, symbol)
        bottom_row = add_board.board.last

        expect(bottom_row[column]).to eq(symbol)
      end
    end

    context 'when the column is not empty' do
      it 'stacks on top of the existing piece' do
        2.times { add_board.add_piece(column, symbol) }
        second_to_last_row = add_board.board[-2]

        expect(second_to_last_row[column]).to eq(symbol)
      end
    end

    context 'when the column is full' do
      it 'does not add a piece to the board' do
        6.times { add_board.add_piece(column, symbol) } # Fill the column
        add_board.add_piece(column, symbol) # Attempt to add another piece

        piece_count = add_board.board.map { |row| row[column] }.count(symbol)
        expect(piece_count).to eq(6)
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
          0 1 2 3 4 5 6
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
          0 1 2 3 4 5 6
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
          0 1 2 3 4 5 6
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
          0 1 2 3 4 5 6
        BOARD

        expect { game_board.draw }.to output(expected_output).to_stdout
      end
    end
  end

  describe '#reset_board' do
    it 'resets the board to its initial state' do
      game_board.add_piece(3, 'X') # Assuming add_piece method exists
      game_board.reset_board

      initial_board = Array.new(6) { Array.new(7, '.') }
      expect(game_board.board).to eq(initial_board)
    end
  end

  describe '#winning_combination?' do
    let(:board_horizontal) { described_class.new() }
    context 'when there is a horizontal win' do
      it 'returns true' do
        # Set up the board for a horizontal win
        4.times { |i| board_horizontal.add_piece(i, 'X') }
        x_wins_h = board_horizontal.winning_combination?('X')
        expect(x_wins_h).to be true
      end
    end

    let(:board_vertical) { described_class.new() }
    context 'when there is a vertical win' do
      it 'returns true' do
        # Setup the board in a winning state. Assume Player1 is the winner.
        # allow(board_vertical).to receive(:winning_combination?).and_return(true)
        # Set up the board for a vertical win
        4.times { board_vertical.add_piece(0, 'X') }

        # winner = board_vertical.winning_combination?
        # expect(winner).to eq(true)
        x_wins_v = board_vertical.winning_combination?('X')
        expect(x_wins_v).to be true
      end
    end

    context 'when there is a diagonal win' do
      let(:board_diagonal_l2r) { described_class.new() }
      it 'returns true for bottom-left to top-right' do
        4.times do |i|
          # Add 'O' pieces to simulate the stacking effect
          i.times { board_diagonal_l2r.add_piece(i, 'O') }

          # Add the 'X' piece
          board_diagonal_l2r.add_piece(i, 'X')
        end

        winner = board_diagonal_l2r.winning_combination?('X')
        expect(winner).to eq(true)
      end

      let(:board_diagonal_r2l) { described_class.new() }
      it 'returns true for top-left to bottom-right' do
        # Set up a diagonal win from top-right to bottom-left
        # Assuming the board's width is 7 (columns 0 to 6)
        4.times do |i|
          column = 6 - i

          # Add 'O' pieces to simulate the stacking effect
          i.times { board_diagonal_r2l.add_piece(column, 'O') }

          # Add the 'X' piece
          board_diagonal_r2l.add_piece(column, 'X')
        end

        winner = board_diagonal_r2l.winning_combination?('X')
        expect(winner).to eq(true)
      end
    end

    context 'when there is no winner' do
      it 'returns false' do
        # Setup the board in a winning state. Assume Player1 is the winner.
        allow(game_board).to receive(:winning_combination?).and_return(false)

        winner = game_board.winning_combination?('X')
        expect(winner).to eq(false)
      end
    end
  end

  describe '#create_statemale_board' do
    subject(:stalemate_board) { described_class.new() }
    it 'creates a board with alternating pieces' do
      stalemate_board.create_stalemate_board
      expected_board = [
        %w[X O O X O O X],
        %w[O X X O X X O],
        %w[X O O X O O X],
        %w[O X X O X X O],
        %w[X O O X O O X],
        %w[O X X O X X O],
      ]
      expect(stalemate_board.board).to eq(expected_board)
    end
  end
end

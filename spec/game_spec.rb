require_relative '../lib/game.rb'
require_relative '../lib/board.rb'
require_relative '../lib/player.rb'

describe Game do
  let(:player1) { instance_double("Player", name: 'Alice', symbol: 'X') }
  let(:player2) { instance_double("Player", name: 'Bob', symbol: 'O') }
  let(:board) { instance_double("Board") }
  subject(:game) { described_class.new(player1, player2, board) }

  describe '#initialize' do
    context 'starting a new game and assigning player roles' do
      it 'initializes with two players' do
        expect(game.player1).to eq(player1)
        expect(game.player2).to eq(player2)
      end
    end
  end

  before do
    allow(board).to receive(:reset_board)
    game.setup_game
  end

  describe '#setup_game' do
    context 'when a new game is started' do
      it 'sets the current player to player1' do
        expect(game.current_player).to eq(player1)
      end

      it 'resets the game board' do
        expect(board).to have_received(:reset_board)
      end
    end
  end

  describe '#switch_players' do
    context 'when players alternate turns over the course of the game' do
      it 'switches the current player to other player' do
        game.switch_players
        expect(game.current_player).to eq(player2)
      end

      it 'switches the current player back to the original player' do
        game.switch_players
        game.switch_players
        expect(game.current_player).to eq(player1)
      end
    end
  end

  describe '#player_input' do
    context 'when user number is valid' do
      before do
        valid_input = '3'
        game.instance_variable_set(:@current_player, player1)
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'returns the valid input as an integer' do
        expect(game.player_input).to eq(3)
      end
    end

    context 'when user inputs an incorrect value' do
      before do
        invalid_input = 'abc'
        game.instance_variable_set(:@current_player, player1)
        allow(game).to receive(:gets).and_return(invalid_input)
      end

      it 'returns nil' do
        expect(game.player_input).to be_nil
      end
    end
  end

  describe '#verify_input' do
    let(:player1) { instance_double("Player") } # Player.new("Alice", "X")
    let(:player2) { instance_double("Player") } # Player.new("Bob", "O")
    let(:board) { instance_double("Board") } # Board.new
    subject(:game_verify_input) { described_class.new(player1, player2, board) }

    context 'when given a valid input as argument' do
      it 'returns valid input' do
        valid_input = 3
        verified_input = game_verify_input.verify_input(valid_input)
        expect(verified_input).to eq(3)
      end
    end

    context 'when given invalid input as argument' do
      it 'returns nil' do
        valid_input = 13
        verified_input = game_verify_input.verify_input(valid_input)
        expect(verified_input).to eq(nil)
      end
    end
  end

  describe '#update_board' do
    let(:column) { 3 }

    before do
      allow(player1).to receive_messages(name: "Alice", symbol: "X")

      allow(board).to receive(:add_piece)
      game.update_board(column)
    end

    it 'adds a piece to the board in the specified column' do
      expect(board).to have_received(:add_piece).with(column, game.current_player.symbol)
    end
  end

  describe '#take_turn' do
    let(:player1_turn) { instance_double("Player", name: 'Alice', symbol: 'X') }
    let(:player2_turn) { instance_double("Player", name: 'Bob', symbol: 'O') }
    let(:board_turn) { instance_double("Board") }
    subject(:game_turn) { described_class.new(player1_turn, player2_turn, board_turn) }

    before do
      allow(game_turn).to receive(:puts)
      allow(game_turn).to receive(:player_input).and_return(3)
      allow(board_turn).to receive(:add_piece)
    end

    context 'when the move is valid' do
      it 'prompts the current player to choose a column' do
        expect(game_turn).to receive(:puts).with("#{game_turn.current_player.symbol}, choose a column:")
        game_turn.take_turn
      end

      it 'adds a piece to the board in the chosen column' do
        expect(board_turn).to receive(:add_piece).with(3, game_turn.current_player.symbol)
        game_turn.take_turn
      end
    end

    context 'when non-numeric input is given' do
      before { allow(game_turn).to receive(:gets).and_return('invalid', '3') }

      xit 'prompts the player for a valid input when non-numeric input is given' do
        allow(game_turn).to receive(:player_input).and_return('invalid', '3')
        expect(game_turn).to receive(:puts).with(/X, choose a column:/).ordered
        expect(game_turn).to receive(:puts).with(/Invalid move/).ordered
        game_turn.take_turn
      end
    end
  end

  describe '#check_winner' do
    context 'when there is a winner' do
      it 'returns that there is a winner' do
        # Setup the board in a winning state. Assume Player1 is the winner.
        allow(player1).to receive_messages(name: "Alice", symbol: "X")
        allow(board).to receive(:winning_combination?).with(player1.symbol).and_return(true)
        winner = game.check_winner
        expect(winner).to eq(player1)
      end
    end

    context 'when there is no winner' do
      it 'returns nil' do
        allow(player1).to receive_messages(name: "Alice", symbol: "X")
        allow(board).to receive(:winning_combination?).with(player1.symbol).and_return(false)
        winner = game.check_winner
        expect(winner).to eq(nil)
      end
    end
  end

  describe '#check_draw' do
    let(:player1_draw) { instance_double("Player") } # Player.new("Alice", "X")
    let(:player2_draw) { instance_double("Player") } # Player.new("Bob", "O")
    let(:stalemate_board) { instance_double("Board") } # Board.new
    subject(:game_check_draw) { described_class.new(player1_draw, player2_draw, stalemate_board) }

    context 'check for a draw' do
      it 'returns true' do
        allow(stalemate_board).to receive(:board_full?).and_return(true)

        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(false)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(true)
      end

      it 'returns false because board not full' do
        allow(stalemate_board).to receive(:board_full?).and_return(false)

        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(false)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(false)
      end

      it 'returns false because player1 is a winner' do
        allow(stalemate_board).to receive(:board_full?).and_return(true)
        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(true)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(false)
      end

      it 'returns false because player2 is a winner' do
        allow(stalemate_board).to receive(:board_full?).and_return(true)
        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(false)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(true)
        draw = game_check_draw.check_draw
        expect(draw).to eq(false)
      end
    end
  end

  describe '#announce_results' do
    let(:player1_results) { instance_double("Player") } # Player.new("Alice", "X")
    let(:player2_results) { instance_double("Player") } # Player.new("Bob", "O")
    let(:board_results) { instance_double("Board") } # Board.new
    subject(:game_results) { described_class.new(player1_results, player2_results, board_results) }
    context 'when there is a winner' do
      it 'displays the winner -> player1' do
        allow(player1).to receive_messages(name: "Alice", symbol: "X")
        allow(game_results).to receive(:check_winner).and_return(player1)
        winner_message = "X wins!"
        expect(game_results).to receive(:puts).with(winner_message)
        game_results.announce_results
      end
      it 'displays the winner -> player2' do
        allow(player2).to receive_messages(name: "Bob", symbol: "O")
        allow(game_results).to receive(:check_winner).and_return(player2)
        winner_message = "O wins!"
        expect(game_results).to receive(:puts).with(winner_message)
        game_results.announce_results
      end
    end

    context 'when there is a draw' do
      it 'displays that there is a draw' do
        allow(game_results).to receive(:check_winner).and_return(nil)
        allow(game_results).to receive(:check_draw).and_return(true)

        draw_message = "It's a draw!"
        expect(game_results).to receive(:puts).with(draw_message)
        game_results.announce_results
      end
    end
  end

  describe '#game_over?' do
    let(:player1_over) { instance_double("Player") } # Player.new("Alice", "X")
    let(:player2_over) { instance_double("Player") } # Player.new("Bob", "O")
    let(:board_over) { instance_double("Board") } # Board.new
    subject(:game_over) { described_class.new(player1_over, player2_over, board_over) }

    context 'when there is a winner' do
      it 'returns true' do
        allow(game_over).to receive(:check_winner).and_return(player1_over)
        result = game_over.game_over?
        expect(result).to eq(true)
      end
    end

    context 'when there is a draw' do
      it 'returns true' do
        allow(game_over).to receive(:check_winner).and_return(nil)
        allow(game_over).to receive(:check_draw).and_return(true)
        result = game_over.game_over?
        expect(result).to eq(true)
      end
    end

    context 'when there is no winner and no draw' do
      it 'returns false' do
        allow(game_over).to receive(:check_winner).and_return(nil)
        allow(game_over).to receive(:check_draw).and_return(false)
        result = game_over.game_over?
        expect(result).to eq(false)
      end
    end
  end
end

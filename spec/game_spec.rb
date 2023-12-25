require_relative '../lib/game.rb'
require_relative '../lib/board.rb'
require_relative '../lib/player.rb'

describe Game do
  let(:player1) { instance_double("Player") } # Player.new("Alice", "X")
  let(:player2) { instance_double("Player") } # Player.new("Bob", "O")
  let(:board) { instance_double("Board") } # Board.new
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
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'stops loop and does not display error message' do
        min = game.instance_variable_get(:@min)
        max = game.instance_variable_get(:@max)
        error_message = "Input error! Please enter a number between #{min} or #{max}."
        expect(game).not_to receive(:puts).with(error_message)
        game.player_input
      end
    end

    context 'when user inputs an incorrect value once, then a valid input' do
      before do
        letter = 'q'
        valid_input = '3'
        allow(game).to receive(:gets).and_return(letter, valid_input)
      end

      it 'completes loop and displays error message once' do
        min = game.instance_variable_get(:@min)
        max = game.instance_variable_get(:@max)
        error_message = "Input error! Please enter a number between #{min} or #{max}."
        expect(game).to receive(:puts).with(error_message).once
        game.player_input
      end
    end

    context 'when user inputs two incorrect values, then a valid input' do
      before do
        letter = 'q'
        number = '100'
        valid_input = '3'
        allow(game).to receive(:gets).and_return(letter, number, valid_input)
      end

      it 'completes loop and displays error message twice' do
        min = game.instance_variable_get(:@min)
        max = game.instance_variable_get(:@max)
        error_message = "Input error! Please enter a number between #{min} or #{max}."
        expect(game).to receive(:puts).with(error_message).twice
        game.player_input
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
        allow(stalemate_board).to receive(:is_full?).and_return(true)

        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(false)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(true)
      end

      it 'returns false because board not full' do
        allow(stalemate_board).to receive(:is_full?).and_return(false)

        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(false)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(false)
      end

      it 'returns false because player1 is a winner' do
        allow(stalemate_board).to receive(:is_full?).and_return(true)
        allow(player1_draw).to receive(:symbol).and_return('X')
        allow(player2_draw).to receive(:symbol).and_return('O')
        allow(stalemate_board).to receive(:winning_combination?).with(player1_draw.symbol).and_return(true)
        allow(stalemate_board).to receive(:winning_combination?).with(player2_draw.symbol).and_return(false)
        draw = game_check_draw.check_draw
        expect(draw).to eq(false)
      end

      it 'returns false because player2 is a winner' do
        allow(stalemate_board).to receive(:is_full?).and_return(true)
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
end

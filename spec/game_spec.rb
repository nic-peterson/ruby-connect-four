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

    # When player enters an invalid column number

    # When player enters a column number that is already full

    # When player enters a non-numeric value

    # When player enters a column number that is out of range
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
end

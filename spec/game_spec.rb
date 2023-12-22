require_relative '../lib/game.rb'
require_relative '../lib/board.rb'
require_relative '../lib/player.rb'

describe Game do
  let(:player1) { instance_double("Player") } # Player.new("Alice", "X")
  let(:player2) { instance_double("Player") } # Player.new("Bob", "O")
  let(:board) { instance_double("Board") } # Board.new
  subject(:game) { described_class.new(player1, player2, board) }

  describe '#initialize' do
    it 'initializes with two players' do
      expect(game.player1).to eq(player1)
      expect(game.player2).to eq(player2)
    end
  end

  before do
    allow(board).to receive(:reset_board)
    game.setup_game
  end

  describe '#setup_game' do
    it 'sets the current player to player1' do
      expect(game.current_player).to eq(player1)
    end

    it 'resets the game board' do
      expect(board).to have_received(:reset_board)
    end
  end

  describe '#switch_players' do
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

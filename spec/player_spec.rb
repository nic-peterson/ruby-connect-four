require_relative '../lib/player.rb'

describe Player do
  subject(:player) { described_class.new('Alice', 'X') }

  describe '#initialize' do
    it 'creates a player with a name' do
      expect(player.name).to eq('Alice')
    end

    it 'creates a player with a symbol' do
      expect(player.symbol).to eq('X')
    end
  end
end

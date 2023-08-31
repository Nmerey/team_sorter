# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  let!(:player_one) { Player.create(name: 'Merey', t_id: 1234) }
  let(:player_two) { Player.new(name: 'Merey', t_id: 1234) }
  describe 'When not valid params passed' do
    it 'should validate uniqueness of t_id' do
      expect(player_two.save).to be(false)
    end
  end
end

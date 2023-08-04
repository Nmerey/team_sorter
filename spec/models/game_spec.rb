require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game_one){ Game.create( venue_id: 123, player_id: 123 ) }
  let(:game_two){ Game.new( venue_id: 123, player_id: 123 ) }
  
  describe "When not valid params passed" do
    it "should validate uniqueness of player and venue" do
      expect(game_two.save).to be(false)
    end
  end
end

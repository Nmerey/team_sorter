require 'rails_helper'

module PlayerServices
	RSpec.describe DivideToTeams do 

		subject { described_class.new }

		let(:players) { build_list(:player, 9) }
		let(:venue) { build(:venue, ownder_id: players.first.id) }

		it 'divides players to balanced teams' do 
			
		end
	end
end
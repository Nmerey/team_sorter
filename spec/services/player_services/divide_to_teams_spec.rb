require 'rails_helper'

module PlayerServices
	RSpec.describe DivideToTeams do 

		subject { described_class }

		let(:players) { build_list(:player, 15) }
		let(:venue) { build(:venue) }
		let(:teams_count) { 3 }
		let(:games) { players.each { |player| Game.create(player, venue) } }
		let(:average_rating) { players.sum(&rating) / teams_count }

		it 'divides players to balanced teams' do
			divided_teams = subject.new(venue, teams_count, players.count).call
			result 				= divided_teams.each { |team| abs(team.sum(&rating) - average_rating) < 1 }
			expect(result.all?(true)).to be(true)
		end
	end
end
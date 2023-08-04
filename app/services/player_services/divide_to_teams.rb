module PlayerServices
	class DivideToTeams

		attr_reader :venue, :teams_count, :players_count

		def initialize(venue, teams_count, players_count)
			@venue = venue
			@teams_count = teams_count
			@players_count = players_count
		end

		def call
			@players = @venue.players.first(@players_count)
			team_size = @players_count / teams_count
			avrg = @players.sum(&:rating) / teams_count
			result = []

			until @players.blank?
				combinations = find_combinations(@players, team_size)
				# Finds perfectly balanced team and pops it from players list
				valid_team = find_random_valid_team(combinations, avrg)
				valid_team = @players if @players.count == team_size
				# Gives second best option if no perfectly balanced team
				valid_team = find_best_diff_team(combinations, avrg) if valid_team.blank?
				@players = @players - valid_team
				result << valid_team
			end

			result
		end

		private

		def find_best_diff_team(combinations, avrg)
			combinations.sort_by { |team| (team.sum(&:rating) - avrg).abs }.first
		end

		def find_combinations(players, team_size)
			players.to_a.combination(team_size)
		end

		def find_random_valid_team(combinations, avrg)
			combinations.find_all{ |team| team.sum(&:rating) == avrg }.sample
		end
	end
end
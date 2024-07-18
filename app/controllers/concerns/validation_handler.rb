module ValidationHandler extend ActiveSupport::Concern
	included do

		def valid_rating_data?(data)
			return false unless data.present?

			rating = is_valid_rating?(data[1])
			player_index = is_valid_player_index?(data[0].to_i - 1)

			rating && player_index
		end

		def is_valid_player_index?(index)
			index <= @venue.players.count
		end

		def is_valid_date?(date)
			pattern =  /^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])$/
			pattern.match?(date)
		end

		def is_valid_change_rating_args?(rating, player)
			is_valid_rating?(rating)
			player.present?
		end

		def is_valid_friend_args?(friend_data)
			rating = friend_data[1]
			is_valid_rating?(rating)
		end

		def is_valid_rating?(rating)
			pattern = /^(10(\.0)?|\d(\.\d)?)$/ # Matches float number from 0 to 10.0
			pattern.match?(rating)
		end

		def is_valid_division_args?(teams_count, players_count, total_players)
			(players_count % teams_count) == 0 && players_count <= total_players
		end

		def something_went_wrong
			respond_with :message, text: 'Something went wrong!'
		end

		def wrong_argument_error
			respond_with :message, text: "Wrong Arguments"
		end
	end
end
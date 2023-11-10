module ValidationHandler extend ActiveSupport::Concern
	included do

		def check_date(date)
			pattern =  /^\d{2}\.\d{2}$/
			raise wrong_argument_error unless !!(date =~ pattern)
		end

		def check_change_rating_args(rating, player)
			check_rating(rating)
			raise wrong_argument_error unless player
		end

		def check_friend_args(friend_data)
			rating = friend_data[1]
			check_rating(rating)
		end

		def check_rating(rating)
			pattern = /^(10(\.0)?|\d(\.\d)?)$/ # Matches float number from 0 to 10.0
			raise wrong_argument_error unless !!(rating =~ pattern)
		end

		def check_division_args(teams_count, players_count, total_players)
			raise wrong_argument_error unless (players_count % teams_count) == 0
			raise wrong_argument_error unless players_count =< total_players
		end

		def something_went_wrong
			respond_with :message, text: 'Something went wrong!'
		end

		def wrong_argument_error
			respond_with :message, text: "Wrong Arguments"
		end
	end
end
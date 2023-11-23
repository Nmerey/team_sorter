module ValidationHandler extend ActiveSupport::Concern
	included do

		def check_date(date)
			pattern =  /^\d{2}\.\d{2}$/
			unless !!(date =~ pattern)
				wrong_argument_error
				raise ActiveJob::DeserializationError
			end
		end

		def check_change_rating_args(rating, player)
			check_rating(rating)
			unless player
				wrong_argument_error
				raise ActiveJob::DeserializationError
			end
		end

		def check_friend_args(friend_data)
			rating = friend_data[1]
			check_rating(rating)
		end

		def check_rating(rating)
			pattern = /^(10(\.0)?|\d(\.\d)?)$/ # Matches float number from 0 to 10.0
			unless !!(rating =~ pattern)
				wrong_argument_error
				raise ActiveJob::DeserializationError
			end
		end

		def check_division_args(teams_count, players_count, total_players)
			unless (players_count % teams_count) == 0 && players_count <= total_players
				wrong_argument_error
				raise ActiveJob::DeserializationError
			end
		end

		def something_went_wrong
			respond_with :message, text: 'Something went wrong!'
		end

		def wrong_argument_error
			respond_with :message, text: "Wrong Arguments"
		end
	end
end
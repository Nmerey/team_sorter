module TelegramWebhookServices
	class CallbackQueryHandler
		# methods that are sent as data are :add_player, :remove_player, :add_friend, :remove_friend, :sort_teams
		def initialize(data)
			@data = data			
		end

		def call
			send(data)
		end

		private

		attr_reader :data

		def add_player
			Game.create(player: @player, venue: @venue)
		end

		def remove_player
			player = Player.find_by(t_id: from['id'])
			game = Game.find_by(venue: @venue, player: @player)
			game.destroy
		end

		def add_friend
			respond_with: message, text: "Give name and rating. e.g(Chapa 5.5)"
			save_context :add_friend
		end

		def remove_friend
			@venue.players.where(friend_id: from['id']).last.destroy
		end

		def sort_teams
			if authorized?
				session[:venue_id] = @venue.id
				respond_with :message, text: 'Number of Teams and Players (ex. 3 15)'
				save_context :sort_teams
			else
				not_authorized_message
			end
		end
	end
end
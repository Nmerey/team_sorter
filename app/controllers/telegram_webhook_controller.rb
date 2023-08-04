class TelegramWebhookController < Telegram::Bot::UpdatesController
	include Telegram::Bot::UpdatesController::MessageContext
	before_action :set_venue, only: [:callback_query, :sort_teams]

	def ping!
		respond_with :message, text: 'pong'
	end

	REPLY_MARKUP = {
		inline_keyboard: [
			[
				{text: '+', callback_data: "add"},
				{text: '-', callback_data: "minus"},
			],
			[
				{text: 'Add Friend', callback_data: "add_friend"},
				{text: "Remove Friend", callback_data: "remove_friend"},
			],
			[
				{text: "Sort Teams", callback_data: "sort_teams"},
			],
		],
	}

	def start!(*)
		respond_with :message, text: 'Location?'
		save_context :get_location
	end

	def get_location(*location)
		session[:location] = location.join(" ")

		respond_with :message, text: 'Date? (ex. 23.04)'
		save_context :get_date
	end

	def get_date(date)
		session[:date] = typed_date(date)

		respond_with :message, text: 'Time? (ex. 19.00)'
		save_context :get_time
	end

	def get_time(time)
		session[:time] = time
		finalize_venue
	end

	def callback_query(data)
		case data
		when "add"

			@player = Player.find_or_create_by(t_id: from['id']) do |player|
				player.assign_attributes(player_params)
			end

			@game = Game.create(player: @player, venue: @venue)

			show_edit_reply

		when "minus"

			@player = Player.find_by(t_id: from['id'])
			@game = Game.find_by(venue: @venue, player: @player)
			@game.destroy

			show_edit_reply

		when "add_friend"

      session[:venue_id]  = @venue.id
      session[:callback]  = payload['message']
      session[:friend_id] = from['id']

			respond_with :message, text: "Name and Rating ? (ex. Chapa 5.5)"
			save_context :add_friend

		when "remove_friend"

			@player = @venue.players.where(friend_id: from['id']).last.destroy
			show_edit_reply

		when "sort_teams"

			session[:venue_id] = @venue.id
			respond_with :message, text: 'Number of Teams and Players (ex. 3 15)'
			save_context :sort_teams
		end

		def sort_teams(*teams_data)
			teams_count = teams_data[0].to_i
			players_count = teams_data[1].to_i

			return answer_callback_query('Not enough players!') unless @venue.players.count >= players_count
			sorted_teams = PlayerServices::DivideToTeams.new(@venue, teams_count, players_count).call

			list_of_teams = ""

			sorted_teams.each do |team|
				list_of_teams << "Average Rating: #{ team.sum(&:rating)}\n"
				team.each { |player| list_of_teams << "#{player.name} - #{player.rating}\n" }
				list_of_teams << "\n"
			end

			respond_with :message, text: list_of_teams
		end

		def add_friend(*friend_data)
			@venue = Venue.find(session[:venue_id])
			@player = Player.new(format_friend_params(friend_data))
			payload['message'] = session[:callback]

			if @player.save 
				@game = Game.create(player: @player, venue: @venue)
				show_edit_reply
			else
				friend_not_saved_message
			end
		end
	end

	private

	def divide_teams(players)
		
	end

	def friend_not_saved_message
		respond_with :message, text: "Friend not save! Wrong Name or Rating"
	end

	def typed_date(date)
		[date,Date.today.year.to_s].join(".").to_date.strftime("%A %d.%m")
	end

	def finalize_venue
		@venue = Venue.new(venue_params)


		if @venue.save
			session[:venue_id] = @venue.id
			respond_with :message, text: @venue.markup_text , reply_markup: REPLY_MARKUP
		end
	end

	def player_params
		{
			name: from['first_name'],
			surname: from['last_name'],
			nickname: "@#{from['username']}",
			t_id: from['id']
		}
	end

	def venue_params
		{
			location: session[:location],
			date: session[:date],
			time: session[:time],
			chat_id: chat['id'],
			chat_title: chat['title'],
			owner_id: from['id']
		}
	end

	def format_friend_params(friend_data)
		{
			name: friend_data[0],
			rating: friend_data[1],
			friend_id: session[:friend_id]
		}
	end

	def show_edit_reply
		edit_message :text, text: @venue.markup_text, reply_markup: REPLY_MARKUP
	end

	def set_venue
		@venue ||= Venue.find_by(id: session[:venue_id]) || Venue.where(chat_title: chat['title']).last
	end
end

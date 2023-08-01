class TelegramWebhookController < Telegram::Bot::UpdatesController
	include Telegram::Bot::UpdatesController::MessageContext

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

			if Player.exists?(t_id: from[:id])
				@player = Player.find_by_t_id(from[:id])
			else
				@player = Player.create(player_params)
			end

			@game = Game.create(player: @player, venue: @venue)

			show_edit_reply
		end
	end

	private

	def typed_date(date)
		[date,Date.today.year.to_s].join(".").to_date.strftime("%A %d.%m")
	end

	def finalize_venue
		@venue = Venue.new(venue_params)


		if @venue.save
			session[:venue_id] = @venue.id
			respond_with :message, text: markup_text , reply_markup: REPLY_MARKUP
		end
	end

	def player_params
		{
			name: from[:first_name],
			surname: from[:last_name],
			nickname: from[:nickname],
			t_id: from[:id]
		}
	end

	def venue_params
		{
			location: session[:location],
			date: session[:date],
			time: session[:time],
			chat_id: chat[:id],
			chat_name: chat[:title],
			owner_id: from[:id]
		}
	end

	def show_edit_reply
		edit_message :text, text: markup_text, reply_markup: REPLY_MARKUP
	end

	def list_of_players
		@venue.players.map.with_index(1) { |player, index| "#{index}. #{player.name}" }.join("\n")
	end

	def markup_text
		"#{@venue.title}\n#{list_of_players}"
	end

	def set_venue
		@venue ||= Venue.find_by(id: session[:venue_id]) || Venue.where(chat_title: chat[:title]).last
	end

end

# frozen_string_literal: false

# Helper module for TelegramWebhookController Class
module TelegramWebhookHelper
	REPLY_MARKUP = {
		inline_keyboard: [
			[
				{ text: '+', callback_data: 'add_player' },
				{ text: '-', callback_data: 'remove_player' }
			],
			[
				{ text: 'Add Friend', callback_data: 'add_friend' },
				{ text: 'Remove Friend', callback_data: 'remove_friend' }
			],
			[
				{ text: 'Sort Teams', callback_data: 'sort_teams' }
			]
		]
	}.freeze

	def show_edit_reply
		edit_message :text, text: @venue.markup_text, reply_markup: REPLY_MARKUP
	end

	def formatted_date(date)
		[date, Date.today.year.to_s].join('.').to_date.strftime('%A %d.%m')
	end

	def friend_not_saved_message
		respond_with :message, text: 'Friend not saved! Wrong Name or Rating'
	end

	def list_of_teams(sorted_teams)
		list_of_teams = ''

		sorted_teams.each do |team|
			list_of_teams << "Average Rating: #{team.sum(&:rating)}\n"
			team.each { |player| list_of_teams << "#{player.name} - #{player.rating}\n" }
			list_of_teams << "\n"
		end

		respond_with :message, text: list_of_teams
	end
end

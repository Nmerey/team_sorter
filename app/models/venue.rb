class Venue < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :players, through: :games
	
	def list_of_players
		self.players.map.with_index(1) { |player, index| "#{index}. #{player.name} #{player.nickname}" }.join("\n")
	end

	def markup_text
		"#{self.title}\n\n#{self.list_of_players}"
	end

	def title
		["Location: #{self.location}", "Date: #{self.date}", "Time: #{self.time}"].join("\n")
	end
end

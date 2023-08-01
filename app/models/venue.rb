class Venue < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :players, through: :games
	def title
		["Location: #{self.location}", "Date: #{self.date}", "Time: #{self.time}"].join("\n")
	end
end

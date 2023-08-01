class Player < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :venues, through: :games
end

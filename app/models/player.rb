class Player < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :venues, through: :games
	validates_uniqueness_of :t_id, allow_blank: true

	scope :not_friends, -> { where(friend_id: nil) }
end
class Player < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :venues, through: :games
	has_one :admin
	validates_uniqueness_of :t_id, allow_blank: true

	scope :not_friends, -> { where(friend_id: nil) }
	scope :game_ordered, -> { includes(:games).order('games.created_at') }

	def admin?
		admin.present?
	end

	def fullname
		"#{self.name} #{self.surname}"
	end

	def full_tag
		"#{self.name} #{self.surname} - @#{self.nickname}"
	end
end
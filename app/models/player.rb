# frozen_string_literal: true

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

  def self.played_together_with(current_player)
    where(id: current_player.venues.joins(:players).pluck('players.id'))
  end

  def fullname
    "#{name} #{surname}"
  end

  def full_tag
    "#{name} #{surname} - @#{nickname}"
  end
end

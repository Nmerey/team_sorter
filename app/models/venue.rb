# frozen_string_literal: true

# Venue model class
class Venue < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :players, through: :games

  def list_of_players
    players.game_ordered.map.with_index(1) do |player, index|
      "#{index}. #{player.name} #{player.surname} #{player.nickname} - #{player.rating}"
    end.join("\n")
  end

  def markup_text
    "#{title}\n\n#{list_of_players}"
  end

  def title
    ["Location: #{location}", "Date: #{date}", "Time: #{time}"].join("\n")
  end
end

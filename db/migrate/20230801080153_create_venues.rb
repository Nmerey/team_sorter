# frozen_string_literal: true

class CreateVenues < ActiveRecord::Migration[7.0]
  def change
    create_table :venues do |t|
      t.string :location
      t.string :date
      t.string :time
      t.integer :chat_id, limit: 8
      t.string :chat_title
      t.integer :owner_id, limit: 8

      t.timestamps
    end
  end
end

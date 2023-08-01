class CreateVenues < ActiveRecord::Migration[7.0]
  def change
    create_table :venues do |t|
      t.string :location
      t.string :date
      t.string :time
      t.integer :chat_id
      t.string :chat_name
      t.integer :owner_id

      t.timestamps
    end
  end
end

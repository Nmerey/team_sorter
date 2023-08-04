class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.string :nickname
      t.integer :t_id
      t.integer :friend_id
      t.float :rating, default: 5.0, null: false

      t.timestamps
    end
  end
end

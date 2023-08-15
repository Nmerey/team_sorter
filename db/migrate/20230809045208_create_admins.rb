class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.integer :player_id, limit: 8
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

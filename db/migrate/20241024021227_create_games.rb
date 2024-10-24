class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.timestamps
      t.string :code
      t.integer :status, default: 0
      t.string :admin_uid
      t.integer :day, default: 0
      t.integer :phase, default: 0
    end
  end
end

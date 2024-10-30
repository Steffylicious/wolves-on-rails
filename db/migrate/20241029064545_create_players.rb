class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.timestamps
      t.string :name, null: false
      t.string :uid, null: false
      t.references :game, null: false, foreign_key: true
      t.integer :role, default: 0
      t.boolean :alive, default: true
    end
  end
end

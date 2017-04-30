class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.date :deadline, null: false
      t.integer :max_participants, null: false
      t.string :kind, null: false
      t.integer :min_bet, null: false
      t.integer :max_bet, null: false

      t.timestamps
    end

    add_index :bets, [:name, :deadline], unique: true
  end
end

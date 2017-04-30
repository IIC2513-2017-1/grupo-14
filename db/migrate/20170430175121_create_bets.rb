class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.string :name
      t.text :description
      t.date :deadline
      t.integer :max_participants
      t.string :type
      t.integer :min_bet
      t.integer :max_bet

      t.timestamps
    end
  end
end

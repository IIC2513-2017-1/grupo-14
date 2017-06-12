class CreateWinners < ActiveRecord::Migration[5.0]
  def change
    create_table :winners do |t|

      t.timestamps
    end
    add_reference :winners, :bet, foreign_key: true
    add_reference :winners, :choice, foreign_key: true
  end
end

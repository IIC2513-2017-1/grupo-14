class AddUniqueToChoices < ActiveRecord::Migration[5.0]
  def change
  	add_index :choices, [:value, :bet_id], unique: true
  end
end

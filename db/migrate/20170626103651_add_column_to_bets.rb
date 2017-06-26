class AddColumnToBets < ActiveRecord::Migration[5.0]
  def change
  	add_column :bets, :private, :boolean
  end
end

class AddUniqueToParticipations < ActiveRecord::Migration[5.0]
  def change
  	add_index :participations, [:user_id, :bet_id], unique: true
  end
end

class AddUserRefToParticipations < ActiveRecord::Migration[5.0]
  def change
    add_reference :participations, :user, foreign_key: true
    add_reference :participations, :choice, foreign_key: true
    add_reference :participations, :bet, foreign_key: true
  end
end

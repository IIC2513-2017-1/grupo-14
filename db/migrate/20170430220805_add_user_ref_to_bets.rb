class AddUserRefToBets < ActiveRecord::Migration[5.0]
  def change
    add_reference :bets, :user, foreign_key: true
  end
end

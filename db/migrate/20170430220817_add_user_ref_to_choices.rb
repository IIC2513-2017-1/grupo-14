class AddUserRefToChoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :choices, :bet, foreign_key: true
  end
end

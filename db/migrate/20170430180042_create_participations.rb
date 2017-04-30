class CreateParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.integer :amount, null: false

      t.timestamps
    end
  end
end

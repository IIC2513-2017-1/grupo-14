class CreateChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :choices do |t|
      t.string :value, null: false

      t.timestamps
    end
  end
end

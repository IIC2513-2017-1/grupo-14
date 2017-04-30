class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    t.string   "name", null: false
    t.string   "mail", null: false
    t.string   "password", null: false
    t.string   "role", null: false

      t.timestamps
    end

    add_index :users, :name, unique: true
    add_index :users, :mail, unique: true
  end
end

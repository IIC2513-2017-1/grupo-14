class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
    	t.integer 'friend1_id', null: false
    	t.integer 'friend2_id', null: false

      t.timestamps
    end

    add_index :friends, :friend1_id
    add_index :friends, :friend2_id
    add_index :friends, [Friend.greatest(:friend1_id, :friend2_id), Friend.least(:friend1_id, :friend2_id)], unique: true
  end
end
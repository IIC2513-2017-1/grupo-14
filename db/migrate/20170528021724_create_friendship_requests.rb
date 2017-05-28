class CreateFriendshipRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :friendship_requests do |t|
      t.integer :sender_id, null: false
      t.integer :recipient_id, null: false

      t.timestamps
    end

  end
end

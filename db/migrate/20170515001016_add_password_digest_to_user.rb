class AddPasswordDigestToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :password_digest, :string

  	User.find_each do |user|
      user.password = user.read_attribute(:password)
      user.save
    end
 
    remove_column :users, :password
  end
end

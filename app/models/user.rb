class User < ApplicationRecord
	has_secure_password
	mount_uploader :avatar, AvatarUploader

	validates :password, presence: true, length: {minimum: 6}, confirmation: true, allow_blank: false
	validates :mail, presence: true, uniqueness: true, allow_blank: false, 
	format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :role, inclusion: { in: %w(regular admin mod) }
	validates :name, presence: true, length: {minimum: 1}, allow_blank: false, uniqueness: true

	validate :valid_content_type, on: 'update'
	
	has_many :bets
	has_many :participations

	has_one :avatar

	has_many :friendships, foreign_key: :user_id, class_name: 'Friendship'
	has_many :friends, through: :friendships, source: :friend

	has_many :incoming_requests, foreign_key: :recipient_id, class_name: 'FriendshipRequest'
	has_many :outgoing_requests, foreign_key: :sender_id, class_name: 'FriendshipRequest'
	has_many :request_targets, through: :outgoing_requests, source: :recipient
	has_many :request_senders, through: :incoming_requests, source: :sender

	private

		def valid_content_type
	      errors.add(:avatar, 'is not a valid image file') unless %w(image/jpeg image/png).include? avatar.sanitized_file.content_type
	    end

end

class User < ApplicationRecord
	has_secure_password

	validates :password, presence: true, length: {minimum: 6}, confirmation: true, allow_blank: false
	validates :mail, presence: true, uniqueness: true, allow_blank: false,
	format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :role, inclusion: { in: %w(regular admin mod) }
	validates :name, presence: true, length: {minimum: 1}, allow_blank: false, uniqueness: true
	
	has_many :bets
	has_many :participations

end

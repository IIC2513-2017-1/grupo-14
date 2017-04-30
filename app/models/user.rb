class User < ApplicationRecord
	validates :password, presence: true, length: {minimum: 6}, confimation: true, allow_blank: false
	validates :mail, presence: true, uniqueness: true, allow_blank: false, length: {minimum: 5}
	format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :role, inclusion: { in: %w(regular, admin, mod) }
	validates :name, presence: true, length: {minimum: 1}, allow_blank: false, uniqueness: true
end

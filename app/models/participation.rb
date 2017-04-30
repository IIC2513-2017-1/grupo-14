class Participation < ApplicationRecord
	validates :amount, presence: true, numericality: { greater_than: 0 }, allow_blank: false
end

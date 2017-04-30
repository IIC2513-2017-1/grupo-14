class Participation < ApplicationRecord
	validates :amount, presence: true, numericality: { greater_than: 0 }, allow_blank: false
	validates_uniqueness_of :user_id, scope: [:bet_id]

	belongs_to :user
	belongs_to :choice
	belongs_to :bet
	validate :amount_range

	def amount_range
		if amount < self.bet.min_bet or amount > self.bet.max_bet
			errors.add(:amount, "out of range")
		end
	end
end

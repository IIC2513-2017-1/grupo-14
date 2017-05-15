class Participation < ApplicationRecord
	validates :amount, presence: true, numericality: { greater_than: 0 }, allow_blank: false
	validates_uniqueness_of :user_id, scope: [:bet_id]

	belongs_to :user
	belongs_to :choice
	belongs_to :bet
	validate :amount_range, :valid_user, :valid_choice

	def valid_user
		if user_id == self.bet.user.id
			errors.add(:user_id, "cannot be the creator of the bet")
		elsif self.bet.user.role != 'regular'
			errors.add(:user_id, "must be a regular user")
		end
	end

	def valid_choice
		if bet_id != self.choice.bet_id
			errors.add(:choice_id, "must belong to the specified bet")
		end
	end

	def amount_range
		if amount < self.bet.min_bet or amount > self.bet.max_bet
			errors.add(:amount, "out of range specified in bet")
		end
	end
end

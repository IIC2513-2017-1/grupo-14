class Bet < ApplicationRecord
	validates :name, presence: true, length: { minimum: 3 }, allow_blank: false
	validates :description, presence: true, length: { minimum: 10 }, allow_blank: false
	validates :deadline, presence: true, allow_blank: false
	validates :max_participants, presence: true, allow_blank: false, numericality: { greater_than: 1 }
	validates :min_bet, presence: true, allow_blank: false, numericality: { greater_than: 0 }
	validates :min_bet, presence: true, allow_blank: false,
	numericality: { greater_than: 0, greater_than_or_equal_to: :min_bet }
	validates_uniqueness_of :name, scope: [:deadline]
	validate :deadline_is_in_future

	belongs_to :user
	has_many :choices, dependent: :destroy
	has_many :participations, dependent: :destroy
	accepts_nested_attributes_for :choices

	def deadline_is_in_future
		if deadline.to_date.past? or deadline.today?
			errors.add(:deadline, "can't be in the past")
		end
	end
end

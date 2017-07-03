class Bet < ApplicationRecord
	validates :name, presence: true, length: { minimum: 3 }, allow_blank: false
	validates :description, presence: true, length: { minimum: 10 }, allow_blank: false
	validates :deadline, presence: true, allow_blank: false
	validates :max_participants, presence: true, allow_blank: false, numericality: { greater_than: 1 }
	validates :min_bet, presence: true, allow_blank: false, numericality: { greater_than: 1 }
	validates :max_bet, presence: true, allow_blank: false,
	numericality: { greater_than: 0, greater_than_or_equal_to: :min_bet }
	validates_uniqueness_of :name, scope: [:deadline]
	validate :deadline_is_in_future

	belongs_to :user
	has_many :choices, dependent: :destroy
	has_many :participations, dependent: :destroy
	accepts_nested_attributes_for :choices
	has_one :winner
	has_one :winning_choice, through: :winner, source: :choice

	scope :active, -> { where("deadline > ?", Date.today) }
	scope :not_private, -> { where('private': false) }
	scope :not_owned, lambda { |user| where("user_id != ?", user.id) }
	scope :friend_owned, lambda { |dude| not_owned(dude).where(dude.friends.include?(:user)) }
	scope :bettable, lambda { |user| active.not_owned(user).not_private }
	scope :bettable_private, lambda { |dude| active.friend_owned(dude).where('private': true) }
	scope :accessible, lambda { |user| where(:user == user).or(bettable(user)).or(bettable_private(user)) }

	def deadline_is_in_future
		if deadline.to_date.past? or deadline.today?
			errors.add(:deadline, "can't be in the past")
		end
	end
end

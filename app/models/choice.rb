class Choice < ApplicationRecord
	validates :value, presence: true, length: { minimum: 6 }, allow_blank: false
	validates_uniqueness_of :value, scope: [:bet_id]

	belongs_to :bet
	has_many :participation
end

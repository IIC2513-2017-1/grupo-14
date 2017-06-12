class Winner < ApplicationRecord
	belongs_to :bet
	belongs_to :choice
end

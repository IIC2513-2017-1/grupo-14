class Choice < ApplicationRecord
	validates :value, presence: true, length: { minimum: 6 }, allow_blank: false
end

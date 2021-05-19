class Employer < ApplicationRecord
	belongs_to :profile
	has_many :contract_types
end

class Employer < ApplicationRecord
	#belongs_to :profile
	has_many :contract_types
  
  has_and_belongs_to_many :employees
end

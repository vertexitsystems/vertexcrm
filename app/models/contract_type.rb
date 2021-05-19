class ContractType < ApplicationRecord
	belongs_to :employee
	belongs_to :employer
	enum contract_type: %i[w2 csc]

	validates :employer_id,presence:true
end

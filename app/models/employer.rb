class Employer < ApplicationRecord
	belongs_to :profile
  accepts_nested_attributes_for :profile
  
	has_many :contract_types
  
  has_many :employees
  has_many :invoices
  
  def approved_invoices
    invoices.find(approval_status: 1)
  end
end

class AccountManager < ApplicationRecord
	belongs_to :profile
  accepts_nested_attributes_for :profile
  
	has_many :assistants
end

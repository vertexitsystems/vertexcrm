class AccountManager < ApplicationRecord
	belongs_to :profile
	has_many :assistants
end

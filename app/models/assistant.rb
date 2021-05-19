class Assistant < ApplicationRecord
	belongs_to :profile
	belongs_to :account_manager
end

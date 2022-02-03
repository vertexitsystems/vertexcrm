class Invoice < ApplicationRecord
  belongs_to :employee
  belongs_to :employer
  
  has_one_attached :invoice_file
end

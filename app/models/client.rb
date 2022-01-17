class Client < ApplicationRecord
  validates :company_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  has_many :jobs
  has_many :employees
  
end

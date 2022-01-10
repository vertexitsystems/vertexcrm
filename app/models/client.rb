class Client < ApplicationRecord
  validates :company_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  has_many :jobs
  has_and_belongs_to_many :employees
  
end

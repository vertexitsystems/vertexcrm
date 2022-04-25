class Job < ApplicationRecord
  belongs_to :client
  belongs_to :vendor
  
  #has_many :employees
  has_many :postings
  has_many :employees, through: :postings
  accepts_nested_attributes_for :postings
    
  has_many :timesheets
  
  enum job_type: %i[Remote OnSite InitialRemote] 
  enum contract_type: %i[FullTime C2C W2Only Both]
  
  has_rich_text :content
  
  def status
    return closing_date.blank? ? "Open" : "Close"
  end
  
end

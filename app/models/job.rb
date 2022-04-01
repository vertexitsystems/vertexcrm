class Job < ApplicationRecord
  belongs_to :client
  belongs_to :vendor
  
  has_many :employees
  has_many :timesheets
  
  enum job_type: %i[Remote OnSite InitialRemote] 
  enum contract_type: %i[FullTime C2C W2Only Both]
  
  def status
    return closing_date.blank? ? "Open" : "Close"
  end
  
end

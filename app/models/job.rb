class Job < ApplicationRecord
  belongs_to :client
  belongs_to :vendor, optional: true
  
  #has_many :employees
  #has_many :postings
  #has_many :employees, through: :postings
  has_many :employees
  has_many :work_durations

  #accepts_nested_attributes_for :postings
    
  has_many :timesheets
  
  enum job_type: %i[Remote OnSite InitialRemote] 
  enum contract_type: %i[FullTime C2C W2Only Both]
  
  has_rich_text :content
  
  def status
    return closing_date.blank? ? "Open" : "Close"
  end

  def display_id
    return "JB" + (1..(3-"#{id}".length)).map{|e|"0"}.join() + id.to_s
  end
  
  def vendor_safe
    vendor.blank? ? client : vendor
  end
end

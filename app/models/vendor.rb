class Vendor < ApplicationRecord
	#belongs_to :profile, optional: true
	has_many :work_durations, through: :projects
	
	has_many :jobs
	has_many :projects
	has_many :employees, through: :jobs#:projects

	
  
  #has_and_belongs_to_many :employees
  def name
    company_name.blank? ? "(Not Provided)" : company_name
  end
  
end

class Employee < ApplicationRecord
	belongs_to :profile
	
  	has_many :projects
  	has_many :vendors, through: :projects
  	has_many :work_durations,through: :projects


  	def name
  		self.profile.full_name
  	end
	
end

class Vendor < ApplicationRecord
	belongs_to :profile
	has_many :work_durations, through: :projects
	#has_many :employees

	has_many :projects
	has_many :employees, through: :projects


  	def name
  		self.profile.full_name
  	end
end

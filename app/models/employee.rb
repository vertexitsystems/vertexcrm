class Employee < ApplicationRecord
  after_destroy :destroy_associations
  
	belongs_to :profile
	
  	has_many :projects
  	has_many :vendors, through: :projects
  	has_many :work_durations,through: :projects


  	def name
  		self.profile.full_name
  	end
	
  private

  def destroy_associations
    self.profile.destroy
    self.projects.destroy_all
  end
end

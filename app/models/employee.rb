class Employee < ApplicationRecord
  after_destroy :destroy_associations
  
  mount_uploader :passport, AttachmentsUploader
  mount_uploader :visa, AttachmentsUploader
  mount_uploader :state_id, AttachmentsUploader
  mount_uploader :i9, AttachmentsUploader
  mount_uploader :e_verify, AttachmentsUploader
  mount_uploader :w9, AttachmentsUploader
  mount_uploader :psa, AttachmentsUploader
  mount_uploader :voided_check_copy, AttachmentsUploader
  
	belongs_to :profile
  accepts_nested_attributes_for :profile
  #attr_accessor :profile
	
  	has_many :projects
  	has_many :vendors, through: :projects
  	has_many :work_durations,through: :projects

  
    #has_and_belongs_to_many :clients
    #has_and_belongs_to_many :employers
    belongs_to :client, optional: true
    belongs_to :employer, optional: true
    
    has_many :invoices
    
  def name
    self.profile.name#full_name
  end
	
  private

  def destroy_associations
    self.profile.destroy
    self.projects.destroy_all
  end
  
  public def days_remaining_till_visa_expiry
    visa_expiry.blank? ? 0 : (visa_expiry.to_date - Date.today).to_i
  end
    
end

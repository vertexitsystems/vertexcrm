class Employee < ApplicationRecord
  #after_destroy :destroy_associations
  
  # mount_uploader :passport, AttachmentsUploader
  # mount_uploader :visa, AttachmentsUploader
  # mount_uploader :state_id, AttachmentsUploader
  # mount_uploader :i9, AttachmentsUploader
  # mount_uploader :e_verify, AttachmentsUploader
  # mount_uploader :w9, AttachmentsUploader
  # mount_uploader :psa, AttachmentsUploader
  # mount_uploader :voided_check_copy, AttachmentsUploader
  
  # #mount_uploader :resume, AttachmentsUploader
  

  # mount_uploader :new_hire_package, AttachmentsUploader
  # mount_uploader :po, AttachmentsUploader
  # mount_uploader :offer_letter, AttachmentsUploader
  # mount_uploader :w2_contract, AttachmentsUploader
  # mount_uploader :w4, AttachmentsUploader
  # mount_uploader :direct_deposit_detail, AttachmentsUploader
  # mount_uploader :emergency_contact_form, AttachmentsUploader
  has_one_attached :passport
  has_one_attached :visa
  has_one_attached :state_id
  has_one_attached :i9
  has_one_attached :e_verify
  has_one_attached :w9
  has_one_attached :psa
  has_one_attached :voided_check_copy
  
  has_one_attached :resume

  mount_uploader :new_hire_package
  mount_uploader :po
  mount_uploader :offer_letter
  mount_uploader :w2_contract
  mount_uploader :w4
  mount_uploader :direct_deposit_detail
  mount_uploader :emergency_contact_form
  

  

	belongs_to :profile
  accepts_nested_attributes_for :profile
  #attr_accessor :profile
	
  	# has_many :projects
  	
  	# has_many :work_durations,through: :projects

    has_many :work_durations
    
    #has_and_belongs_to_many :clients
    #has_and_belongs_to_many :employers
    belongs_to :client, optional: true
    belongs_to :employer, optional: true
    
    has_many :invoices
    
    # has_many :postings
    # has_many :jobs, through: :postings
    belongs_to :job

    has_many :vendors, through: :job#s#:projects
    #accepts_nested_attributes_for :postings
    #belongs_to :job, optional: true
    
    has_many :timesheets
    
  def name
    profile.blank? ? "(Profile Missing)" : profile.name
  end
	
  # start_date is larger (newer, 30 july 2022), end_date is smaller (older: 1 junly 2022)
  def work_durations_for_period(start_date, end_date)
    work_durations.where("extract(dow from work_day) = ?", 1)
  end
  
  private

  #def destroy_associations
  #  Profile.find(self.profile.id).destroy unless self.profile.blank?
    #self.profile.destroy
    #self.projects.destroy_all
    #end
  
  public def days_remaining_till_visa_expiry
    visa_expiry.blank? ? 0 : (visa_expiry.to_date - Date.today).to_i
  end

  public def was_active_between(start_date, end_date)
    esd = (job_start_date.blank? ? created_at : job_start_date).to_date
    eed = (job_end_date.blank? ? Date.today : job_end_date).to_date
    
    !(start_date >= esd && end_date <= eed)
  end
  
  # public def active_postings
  #   postings.where(:end_date => nil)
  # end
  # public def active_job
  #   active_postings.first.job unless active_postings.count <= 0
  # end
  
  # public def posting_for_job(job_id)
  #   postings.where(job_id: job_id).first
  # end
    
end

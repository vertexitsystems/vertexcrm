class Profile < ApplicationRecord
  after_destroy :destroy_associations
  
  belongs_to :user
  has_one :employee, dependent: :destroy
  has_one :vendor, dependent: :destroy
  has_one :account_manager, dependent: :destroy
  has_one :employer, dependent: :destroy
  has_one :assistant, dependent: :destroy
  attr_accessor(:email, :password)

  mount_uploader :photo, AttachmentsUploader
  mount_uploader :resume, AttachmentsUploader
  mount_uploader :degree, AttachmentsUploader

  def role
    return 'Applicant' if user_type.nil?

    case user_type
    when 357_168
      'Admin'
    when 3396
      'Employer'
    when 445
      'Employee'
    when 2623
      'Vendor'
    when 7392
      'Account Manager'
    when 6523
      'Assistant'
    else
      'Applicant'
    end
  end

  def self.role_id(key)
    return 0 if key.nil?

    case key.downcase
    when 'Admin'.downcase
      357_168
    when 'Employer'.downcase
      3396
    when 'Employee'.downcase
      445
    when 'Vendor'.downcase
      2623
    when 'Account Manager'.downcase
      7392
    when 'Assistant'.downcase
      6532
    else
      0
    end
  end

  def email
    user.try(:email)
  end
  
  def name 
    if self.first_name.blank?
      self.full_name.blank? ? "(Not Provided)" : self.full_name
    else
      "#{self.first_name} #{self.middle_name} #{self.last_name}"
    end
  end
  
  private
  def destroy_associations
    self.user.destroy
  end
end

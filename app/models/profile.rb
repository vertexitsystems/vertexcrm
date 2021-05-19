class Profile < ApplicationRecord

	belongs_to :user
	has_one :employee, dependent: :destroy
	has_one :vendor, dependent: :destroy
	has_one :account_manager, dependent: :destroy
	has_one :employer, dependent: :destroy
	has_one :assistant, dependent: :destroy
	attr_accessor(:email, :password)
	mount_uploader :photo , AttachmentsUploader
	mount_uploader :resume , AttachmentsUploader
	mount_uploader :degree , AttachmentsUploader

	def role
		if user_type == nil
			return "Applicant"
		end
		case user_type
		when 357168
			return "Admin"
		when 3396
			return "Employer"
		when 445
			return "Employee"
		when 2623
  			return "Vendor"
		when 7392
			return "Account Manager"
		when 6523
			return "Assistant"
		else
			return "Applicant"
		end
	end

	def self.role_id(key)
		if key == nil
			return 0
		end
		case key.downcase
		when "Admin".downcase
			return 357168
		when "Employer".downcase
			return 3396
		when "Employee".downcase
			return 445
		when "Vendor".downcase
  			return 2623
		when "Account Manager".downcase
			return 7392
		when "Assistant".downcase
			return 6532
		else
  			return 0
  	end
	end
	def email
		user.try(:email)
	end

end

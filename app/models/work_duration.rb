class WorkDuration < ApplicationRecord
  belongs_to :project
  has_one :vendor, through: :project
  has_one :employee, through: :project
  enum time_sheet_status: %i[unsubmitted saved pending approved rejected]

  validates :hours, inclusion: { in: 0..13,
                                 message: '%<value>s is not in between 0 to 13' }
  mount_uploader :timesheet_screenshot, AttachmentsUploader
  
  def is_unsubmitted?
    time_sheet_status == "unsubmitted"
  end
  def is_saved?
    time_sheet_status == "saved"
  end
  def is_pending?
    time_sheet_status == "pending"
  end
  def is_approved?
    time_sheet_status == "approved"
  end
  def is_rejected?
    time_sheet_status == "rejected"
  end
  
  def is_past_due_date?
    (DateTime.now - work_day.at_beginning_of_week).to_i >= 14
  end
  
end

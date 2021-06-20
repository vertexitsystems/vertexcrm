class WorkDuration < ApplicationRecord
  belongs_to :project
  has_one :vendor, through: :project
  has_one :employee, through: :project
  enum time_sheet_status: %i[unsubmitted saved pending approved rejected]

  validates :hours, inclusion: { in: 0..13,
                                 message: '%<value>s is not in between 0 to 13' }
  mount_uploader :timesheet_screenshot, AttachmentsUploader
end

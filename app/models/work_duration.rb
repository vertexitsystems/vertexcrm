class WorkDuration < ApplicationRecord
  belongs_to :project
  has_one :vendor, through: :project
  has_one :employee, through: :project
  #enum time_sheet_status: %i[unsubmitted saved pending approved rejected reopened]
  enum time_sheet_status: %i[pending unsubmitted reopened saved approved rejected resubmitted]

  validates :hours, inclusion: { in: 0..13,
                                 message: '%<value>s is not in between 0 to 13' }
  #mount_uploader :timesheet_screenshot, AttachmentsUploader
  has_one_attached :timesheet_screenshot
  
  def is_unsubmitted?
    time_sheet_status == "unsubmitted"
  end
  def is_saved?
    time_sheet_status == "saved"
  end
  def is_pending?
    time_sheet_status == "pending"
  end
  def is_resubmitted?
    time_sheet_status == "resubmitted"
  end
  def is_approved?
    time_sheet_status == "approved"
  end
  def is_rejected?
    time_sheet_status == "rejected"
  end
  def is_reopened?
    time_sheet_status == "reopened"
  end
  
  def is_two_weeks_old?
    (DateTime.now - work_day.at_beginning_of_week).to_i >= 14
  end
  def is_past_due_date?
    return !is_approved? && !is_rejected? && !is_reopened? && is_two_weeks_old?
  end
  
  def should_update?
    return !(is_pending? || is_approved? || (is_past_due_date? && !is_reopened?))
  end
  
  def all_days
    days = []
    start_day = work_day.beginning_of_week
  	(0...5).each do |diff|
      days << WorkDuration.select {|dur| dur.work_day == (start_day + diff) && dur.project_id == project_id }.first
    end
    return days
  end
  
  def display_id
    id.to_s + work_day.strftime("%b").upcase + work_day.strftime("%d") + work_day.strftime("%y").upcase
  end
  
  scope :priority_order, -> {
    order(<<-SQL)
        CASE work_durations.work_day 
        WHEN #{Date.today} THEN 'a'
        ELSE 'z' 
        END ASC, 
        id ASC
      SQL
  }
    
end

class Timesheet < ApplicationRecord
  belongs_to :employee
  belongs_to :job
  
  has_one_attached :screen_shot
  
  enum status: %i[unsubmitted saved pending resubmitted reopened approved rejected past_due]
  
  def last_work_day
    start_date + 4
  end
  
  def total_hours_worked
    monday + tuesday + wednesday + thursday + friday
  end
end

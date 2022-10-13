class WorkDuration < ApplicationRecord
  # belongs_to :project, :optional => true
  # belongs_to :posting, :optional => true
  
  # has_one :vendor, through: :project
  # has_one :employee, through: :project

  belongs_to :employee
  belongs_to :job
  has_one :vendor, through: :job

  #enum time_sheet_status: %i[unsubmitted saved pending approved rejected reopened]
  enum time_sheet_status: %i[pending unsubmitted reopened saved approved rejected resubmitted]

  validates :hours, inclusion: { in: 0..13,
                                 message: '%<value>s is not in between 0 to 13' }
  #mount_uploader :timesheet_screenshot, AttachmentsUploader
  has_one_attached :timesheet_screenshot
  
  
  
  def period
    return "(Bad Value)" if work_day.blank? || sunday.blank? || saturday.blank?
    return "#{sunday.strftime("%b %d, %Y")} - #{saturday.strftime("%b %d, %Y")}"
  end
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
  
#  def all_days
#     days = []
#     start_day = work_day.beginning_of_week
#     (0...5).each do |diff|
#       day = WorkDuration.select {|dur| dur.work_day == (start_day + diff) && dur.project_id == project_id }.first
#       if day.blank?
#         days << WorkDuration.new(:employee => employee, :work_day => (work_day + diff), :time_sheet_status => :unsubmitted)
#       else
#         days << day
#       end
#
#     end
#     return days
#   end
  
  def display_id
    if work_day.blank?
      time_key = "AAA"
    else
      time_key = "#{work_day.strftime("%b").upcase}#{work_day.strftime("%d%y")}"
    end

    "WD#{id}#{time_key}#{mon.to_i < 0 ? "A" : "B"}"
  end
  
  # scope :priority_order, -> {
  #   order(<<-SQL)
  #       CASE work_durations.work_day
  #       WHEN #{Date.today} THEN 'a'
  #       ELSE 'z'
  #       END ASC,
  #       id ASC
  #     SQL
  # }
  
  
  
#   def select_day(check_day)
#     all_days.select{|x|x.work_day == check_day}.first
#   end

  def sunday() work_day - 1 end
  def monday() work_day end
  def tuesday() work_day + 1 end
  def wednesday() work_day + 2 end
  def thursday() work_day + 3 end
  def friday() work_day + 4 end
  def saturday() work_day + 5 end
  
    #Patch: 72205 AA02 - Start
    #
    # We have to do it this way for efficiency
    # For each time period there are two possibilities we might have old data where every hour was stored in saperate record
    # or we might have new structure where each hour is in its own column
    # if its old structure we want to avoid sending 6 different quries for each day, which means we have to load all in single query
    # So we construct an array where each days hours will be placed in sequence (Convention over configuration) and load that with single query
    

    def fetch_hours_array(start_day = -1, end_day = 5)
      
      if (mon.to_i < 0)
        
        return [0,0,0,0,0,0,0,0] if employee.blank?

        wds = employee.work_durations.where(work_day: (work_day + start_day)...(work_day + end_day))
        
        sun_hours = wds.select {|wd|wd.work_day == sunday}.first
        mon_hours = wds.select {|wd|wd.work_day == monday}.first
        tue_hours = wds.select {|wd|wd.work_day == tuesday}.first
        wed_hours = wds.select {|wd|wd.work_day == wednesday}.first
        thu_hours = wds.select {|wd|wd.work_day == thursday}.first
        fri_hours = wds.select {|wd|wd.work_day == friday}.first
        sat_hours = wds.select {|wd|wd.work_day == saturday}.first
        
        return [sun_hours.blank? ? 0 : sun_hours.hours.to_i,
                mon_hours.blank? ? 0 : mon_hours.hours.to_i,
                tue_hours.blank? ? 0 : tue_hours.hours.to_i,
                wed_hours.blank? ? 0 : wed_hours.hours.to_i,
                thu_hours.blank? ? 0 : thu_hours.hours.to_i,
                fri_hours.blank? ? 0 : fri_hours.hours.to_i,
                sat_hours.blank? ? 0 : sat_hours.hours.to_i]
                
      else
        hours_array = []
        hours_array << sun.to_i if start_day < 0
        hours_array << mon.to_i if (start_day <= 0 && end_day >= 0)
        hours_array << tue.to_i if (start_day <= 1 && end_day >= 1)
        hours_array << wed.to_i if (start_day <= 2 && end_day >= 2)
        hours_array << thu.to_i if (start_day <= 3 && end_day >= 3)
        hours_array << fri.to_i if (start_day <= 4 && end_day >= 4)
        hours_array << sat.to_i if end_day >= 5
        return hours_array#[sun.to_i, mon.to_i, tue.to_i, wed.to_i, thu.to_i, fri.to_i, sat.to_i]
      end
    end
    
    # private def worked_hours(diff, value)
    #   (value < 0) ? employee.work_durations.where(work_day: work_day + diff).pluck(:hours).first : value
    # end
    #
    # def mon_hours
    #   (mon < 0) ? hours.to_i : mon.to_i
    # end
    #
    # def tue_hours
    #   worked_hours(1, tue).to_i
    # end
    #
    # def wed_hours
    #   worked_hours(2, wed).to_i
    # end
    #
    # def thu_hours
    #   worked_hours(3, thu).to_i
    # end
    #
    # def fri_hours
    #   worked_hours(4, fri).to_i
    # end
    #
    # def sat_hours
    #   worked_hours(5, sat).to_i
    # end
    #
    # def sun_hours
    #   worked_hours(-1, sun).to_i
    # end
    #
    # def total_hours_worked
    #   sun_hours + mon_hours + tue_hours + wed_hours + thu_hours + fri_hours + sat_hours
    # end
    #Patch: 72205 AA02 - END
end

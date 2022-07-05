class Invoice < ApplicationRecord
  belongs_to :employee
  belongs_to :employer
  
  has_one_attached :invoice_file
  
  def start_date
    if payment_date
      start_date = (payment_date.day > 15) ? payment_date.end_of_month : (payment_date.beginning_of_month + 14)
    end
  end
  def end_date
    end_date = (start_date - 14)
  end
  
  
  def all_work_durations
    wds = []
    curr_day = start_date.beginning_of_week
    while curr_day.beginning_of_week  >= end_date.beginning_of_week 
      #byebug
      wd = employee.work_durations.where(work_day: curr_day).first
      if wd.blank?
        wds.append( WorkDuration.new(project_id: employee.projects.first.id, work_day: curr_day,time_sheet_status:"unsubmitted") )
      else
        wds.append(wd)
      end
      
      curr_day = curr_day.last_week
    end
    
    return wds
  end
  
  def approved_work_durations
    all_work_durations.select{|wd| wd.time_sheet_status == "approved"}
  end
  
  def approved_hours
    active_days = 0
    approved_work_durations.each do |ad|
      # 72202HF1 : Fix app crashing
      result = ad.all_days.select{|d| d.work_day >= end_date && d.work_day <= start_date}.map{|w|w.hours}.reduce(:+)
      active_days += result.blank? ? 0 : result
    end
    return active_days
  end
  
  def approved_amount
    return "$#{approved_hours * employee.employer_rate}"
  end
  
  #Payment Status:
  # 0: not selected
  # 1: Accepted
  # 2: Rejected
  def status
    if !approval_status.blank?
      return approval_status == 1 ? "Approved" : "Rejected" 
    elsif approved_work_durations.count > 0
      "Available"
    else
      "Unsubmitted"
    end
    
  end
  
end

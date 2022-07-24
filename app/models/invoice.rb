class Invoice < ApplicationRecord
  belongs_to :employee
  belongs_to :employer
  
  has_one_attached :invoice_file
  
  max_paginates_per 10

  # start_date is always the higher date
  def start_date
    if payment_date
      start_date = (payment_date.day > 15) ? payment_date.end_of_month : (payment_date.beginning_of_month + 14)
    end
  end
  def end_date
    end_date = (payment_date.day > 15) ? payment_date.change(:day => 16) : payment_date.beginning_of_month#(start_date - 14)
  end
  
  
  def all_work_durations
    wds = []
    
    if start_date.blank?
      return wds
    end
    
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
      result = ad.fetch_hours_array.reduce(:+)#.all_days.select{|d| d.work_day >= end_date && d.work_day <= start_date}.map{|w|w.hours}.reduce(:+)
      active_days += result.blank? ? 0 : result
    end
    return active_days
  end
  
  def approved_amount
    return "$#{approved_hours.to_i * employee.employer_rate.to_i}"
  end
  
  
  def available?() (approval_status.blank? || approval_status == 0) && approved_work_durations.count > 0 end
  def pending?() approval_status == 1 end
  def rejected?() approval_status == 4 end
  
  def status
    case approval_status
    when nil, 0 # available / unsubmitted
      return approved_work_durations.count > 0 ? "available" : "unsubmitted"
    when 1 # Pending
      return "pending"
    when 2 # Reopened
      return "reopened"
    when 3 # Approved
      return "approved"
    when 4 # Rejected
      return "rejected"
    else
    end
      
    # # Invoice payment_status is false can mean two things, the sheet is either unsubmitted/reopened or its rejected
    # # If payment_rejection_message is blank then its the first option "unsubmitted/reopened" otherwise its rejected
    # if !payment_status && payment_rejection_message.blank?
    #   # the sheet is either unsubmitted or it was reopned
    #   return approved_work_durations.count > 0 ? "Available" : "Unsubmitted"
    # else
    #   # the sheet is submitted
    #   if payment_status && payment_rejection_message.blank?
    #     # timesheet is approved
    #     return "Approved"
    #   elsif !payment_status && !payment_rejection_message.blank?
    #     # timesheet is reject
    #     return "Rejected"
    #   else # payment_status => true/false,
    #     # timesheet is still pending
    #     return "Pending"
    #   end
    # end
  end
  
  # buyer: client
  # supplier: vendor
  # contingent : charter
  
  # #Payment Status:
  # # 0: not selected
  # # 1: Accepted
  # # 2: Rejected
  # def status
  #   if !approval_status.blank?
  #     return approval_status == 1 ? "Approved" : "Rejected"
  #   elsif approved_work_durations.count > 0
  #     "Available"
  #   else
  #     "Unsubmitted"
  #   end
  #
  # end
  
end

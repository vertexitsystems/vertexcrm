# Preview all emails at http://localhost:3000/rails/mailers/work_duration_mailer
class WorkDurationMailerPreview < ActionMailer::Preview
  
  def work_duration_status_changed_email
    # Set up a temporary order for the preview
    
    # Test Rejected
    wd = WorkDuration.new(hours:8,work_day:Date.today,project_id:1,time_sheet_status:"rejected",rejection_message:"Wrong number of hours given")
    # Test Approved
    #wd = WorkDuration.new(hours:8,work_day:Date.today,project_id:1,time_sheet_status:"approved")
    
    WorkDurationMailer.with(work_duration: wd).work_duration_status_changed_email
  end
  
end

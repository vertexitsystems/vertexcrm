class WorkDurationMailer < ApplicationMailer
  def work_duration_status_changed_email
      @wd = params[:work_duration]
      
      mail(to: @wd.employee.profile.email, subject: "Time Sheet #{@wd.is_approved? ? "Accepted" : "Rejected" } for period #{@wd.period}")
    end
end

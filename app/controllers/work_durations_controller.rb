class WorkDurationsController < ApplicationController
  # before_action :set_work_duration, only: [:show,:destroy]
  before_action :authenticate_user!
  before_action :validate_access!, only: [:index]
  
  def validate_access!
    if !(current_user.is_admin? || current_user.is_account_manager?)
      redirect_to root_path
    end
  end  
  # GET /work_durations
  # GET /work_durations.json
  def index
    @work_durations = WorkDuration.all
  end

  # GET /work_durations/1
  # GET /work_durations/1.json

  # GET /work_durations/new
  def new
    @work_duration = WorkDuration.new

    pid = params[:pid].nil? ? current_user.profile.id : params[:pid]
    @employee = Profile.where(id: pid).first.employee
  end

  # GET /work_durations/1/edit
  def edit
    @work_duration = WorkDuration.find(params[:id])
    eid = params[:eid].nil? ? current_user.id : params[:eid]
    @employee = Employee.where(id: eid).first
  end

  
  def weekly_wise_data
    @employee = Employee.find(params[:eid])
    all_work_durations = @employee.work_durations.group_by { |w| w.work_day.beginning_of_week.strftime('%B %d, %Y') }
    @work_durations = all_work_durations[params[:date].to_s]
    @date = params[:date]
    @work_duration = WorkDuration.new
    respond_to do |format|
      format.html
    end
  end
  
  def weekly_update
    today = Date.today
    @employee = Employee.find(params[:eid])
    all_work_durations = @employee.work_durations.group_by { |w| w.work_day.beginning_of_week.strftime('%B %d, %Y') }
    @work_durations = all_work_durations[params[:date].to_s]
    message = ''
    (today.at_beginning_of_week..today.at_end_of_week).map.each_with_index do |day, index|
      @work_duration = @work_durations.select { |w| w if w.work_day.strftime('%A') == day.strftime('%A') }.first
      # extract the number of hours for each
      @work_duration.hours = params[%w[a b c d e f g][index] + @work_duration.id.to_s].to_i
      @work_duration.time_sheet_status = if save_for_later
                                           'saved'
                                         else
                                           'pending'
                                         end
      if @work_duration.save
        message = 'successfully Saved'
      else
        break
        message = @hw.errors
      end
    end

    respond_to do |format|
      if @work_duration.save
        format.html { redirect_to @employee, notice: 'Work duration was successfully created.' }
        format.json { render :show, status: :created, location: @work_duration }
      else
        format.html { redirect_to weekly_wise_data_work_durations_url(eid: @employee.id, date: params[:date]) }
        format.json { render json: @work_duration.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def reopen_timesheet
    
    work_duration = WorkDuration.where(id:params[:id]).first
    
    if work_duration.blank?
      
      employee = Employee.where(id:params[:emp].to_i).first
        
      ap = employee.active_postings.first
    
      work_duration = WorkDuration.new(work_day:params[:date].to_date,
                                       project_id: employee.projects.first.id,
                                       posting_id: ap.id,
                                       job_rate: ap.posting_rate,
                                       time_sheet_status:"reopened")
      
       if work_duration.save
         flash[:notice] = "Timesheet Reopened"
         redirect_back(fallback_location: root_path)
       else
         flash[:error] = "Failed to update timesheet."
         redirect_back(fallback_location: root_path)
       end
       
    else
      
      if work_duration.posting_id.blank?
        ap = work_duration.employee.active_postings.first

        if ap.blank?
          flash[:alert] = "Unable to reopen timesheet because the consultant has no active postings"
          redirect_back :fallback_location => root_path
          return
        end

        work_duration.posting_id = ap.id
        work_duration.job_rate = ap.posting_rate
      end
      
      if work_duration.update(time_sheet_status:"reopened")
        flash[:notice] = "Timesheet Reopened"
        redirect_back(fallback_location: root_path)
      else
        flash[:error] = "Failed to update timesheet."
        redirect_back(fallback_location: root_path)
      end
      
    end
    
    
    
  end
  
  def show
    if WorkDuration.where(id:params[:id]).count <= 0
      redirect_to root_path
      return
    end
    @work_duration = WorkDuration.find(params[:id])
    
    if params[:reset_all].present?
      WorkDuration.all.each do |wd|
        if ((2.weeks.ago)..(Date.today)).include?(wd.work_day)
          puts "Set to Unsubmitted"
          wd.update(time_sheet_status: 1)
        else
          puts "Set to Pending"
          wd.update(time_sheet_status: 0)
        end
        
      end
    end
    
  end

  # POST /work_durations
  # POST /work_durations.json
  def create
    
#    all_saved = true
    
    save_for_later = params[:save_for_later].present?
    
    employee = Employee.where(id: params['eid']).first
    posting = (params[:pid].present? && !params[:pid].blank?) ? Posting.find(params[:pid]) : employee.active_postings.first
    
    #project = Project.where(id: params['pid']).first
    
    work_duration = WorkDuration.find(params[:wdid]) if params[:wdid].present?
    
    if work_duration.blank?
      
      ap = employee.active_postings.first
      
      work_duration = WorkDuration.new(work_day:params[:dt],
                                       project_id: employee.projects.first.id,
                                       posting_id: ap.id,
                                       job_rate: ap.posting_rate)
      
    end
    
    work_duration.sun = params[:sun]
    work_duration.mon = params[:mon]
    work_duration.tue = params[:tue]
    work_duration.wed = params[:wed]
    work_duration.thu = params[:thu]
    work_duration.fri = params[:fri]
    work_duration.sat = params[:sat]
    work_duration.save_for_later = save_for_later
    work_duration.created_at = DateTime.now
    work_duration.contract_type = employee.contract_type
    work_duration.employer_rate = employee.employer_rate
    work_duration.consultant_rate = employee.rate
    
    if work_duration.posting_id.blank?
      ap = employee.active_postings.first

      if ap.blank?
        flash[:alert] = "Unable to create timesheet because the consultant has no active postings"
        redirect_back :fallback_location => root_path
        return
      end

      work_duration.posting_id = employee.active_postings.first.id
      work_duration.job_rate = ap.posting_rate
    end
    
    work_duration.time_sheet_status = save_for_later ? 'saved' : (work_duration.time_sheet_status == "reopened") ? 'resubmitted' : 'pending'
    
    work_duration.timesheet_screenshot.attach(params[:timesheet_screenshot]) if params[:timesheet_screenshot] != nil
    
    
    
    if work_duration.save
      flash[:notice] = "Timesheet #{save_for_later ? "Saved" : "Submitted" } Successfully"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "Failed to save Timesheet: #{@work_duration.errors}"
      redirect_back(fallback_location: root_path)
    end
#     # IMPLEMENT: Server side authentication
#     # Make sure time sheet is attached to any work duration that is submitted for monday.. if not then we return with error measage
#     # monday_string = params["wds"].first.select{|ds| project.work_durations.where(work_day: DateTime.parse(ds)).first.work_day.monday? }.keys.first
#     # monday = project.work_durations.where(work_day:DateTime.parse(monday_string))
#     #
#     # FIX THIS CHECK # if !monday.timesheet_screenshot.attached?
#     #   format.html { redirect_to employee, flash: { error: "Timesheet Image must be provided." } }
#     #   reutrn
#     # end
#
#
#     #iterate over all dates sent via params convert
#     params["wds"].first.keys.each do |date_key|
#       ## convert key into date and fetch work duration from project for the converted date
#       date = DateTime.parse(date_key)
#
#       work_duration = project.work_durations.where(work_day: date).first
#
#       ## if work duration not nil
#       if !work_duration.blank?
#         ### change hours to value
#         work_duration.hours = params["wds"].first[date.strftime("%b,%d,%Y")].to_i
#         ### change status to pending if save_for_later else saved
#         work_duration.time_sheet_status = save_for_later ? 'saved' : (work_duration.time_sheet_status == "reopened") ? 'resubmitted' : 'pending'
#         ### we also change the created_at date because this date is used to signify when the timesheet was submitted
#         work_duration.created_at = DateTime.now
#
#         if params[:timesheet_screenshot] != nil && date.strftime('%A') == 'Monday'
# #          work_duration.timesheet_screenshot = params[:timesheet_screenshot] if date.strftime('%A') == 'Monday'
#           work_duration.timesheet_screenshot.attach(params[:timesheet_screenshot])
#         end
#       else
#
#         work_duration = employee.projects.first.work_durations.create(work_day: date)
#
#         work_duration.hours = params["wds"].first[date.strftime("%b,%d,%Y")].to_i
#
#         work_duration.created_at = DateTime.now
#
#         # we want to set the status of all created dates same as monday to maintain cohearence
#         if date.monday?
#           # so we check if the date being created is monday? if it is then we simply check if its being saved or submitted and set the status accordingly
#           # if monday did not already exits then it is not possible for it be resubmitted currently because timesheet is created in update_duration_status if doesnt exist
#           work_duration.time_sheet_status = save_for_later ? 'saved' : 'pending'
#         else
#           # if its not monday then we fetch monday and set the same status it has
#           work_duration.time_sheet_status = employee.projects.first.work_durations.where(work_day: date.beginning_of_week).first.time_sheet_status
#         end
#
#
#         if params[:timesheet_screenshot] != nil && date.strftime('%A') == 'Monday'
#           work_duration.timesheet_screenshot.attach(params[:timesheet_screenshot])
#         end
#
#       end
#       # save work duration
#       if !work_duration.save
#         all_saved = false
#       end
#       #end iteration
#     end
#
#     respond_to do |format|
#       if all_saved
#         format.html { redirect_to employee, notice: 'Work duration was successfully created.' }
#         format.json { render :show, status: :created, location: @work_duration }
#       else
#         format.html { redirect_to employee, flash: { error: "Some Values not saved. Please try again." } }
#       end
#     end
  end

  # PATCH/PUT /work_durations/1
  # PATCH/PUT /work_durations/1.json
  def update
    @work_duration = WorkDuration.find(params[:id])
    respond_to do |format|
      if @work_duration.update(work_duration_params)
        format.html { redirect_to @work_duration.employee, notice: 'Work duration was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_duration }
      else
        format.html { render :edit }
        format.json { render json: @work_duration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_durations/1
  # DELETE /work_durations/1.json
  def destroy
    @work_duration = WorkDuration.find(params[:id])
    @work_duration.destroy
    respond_to do |format|
      format.html { redirect_to work_durations_url, notice: 'Work duration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_duration_status
    
    # action_id is the id of work_duration
    if !params["action_id"].present? || params["action_id"].blank?
      respond_to do |format|
        format.html { redirect_to :back, alert: "Failed to update Timesheet status. Error: action_id not provided." }
        format.json { render json: {result:false, id: params["action_id"], status:wd.time_sheet_status} }
      end
      return
    end
    
    wd = WorkDuration.find(params["action_id"])
    
    wd.time_sheet_status = params["status"]
    wd.rejection_message = params["reason"]
    wd.status_read = true # IF this value is true consultatnt will see notification for status change
    
    if wd.posting_id.blank?
      posting = wd.employee.active_postings.first
      wd.posting_id = posting.id unless posting.blank?
    end
    
    if wd.save
      # if status has changed to accepted or rejected then we send and email to the consultant to let them know
      if wd.is_approved? || wd.is_rejected?
        WorkDurationMailer.with(work_duration: wd).work_duration_status_changed_email.deliver_now
      end
      
      respond_to do |format|
        format.html { redirect_to time_sheet_approval_account_managers_path, notice: 'Work duration was successfully updated.' }
        format.json { render json: {result:true, id: params["action_id"], status:wd.time_sheet_status} }
      end
      
    else
      respond_to do |format|
        format.html { redirect_to time_sheet_approval_account_managers_path, alert: "Failed to update Timesheet status. #{wd.errors.full_messages.to_sentence}" }
        format.json { render json: {result:false, id: params["action_id"], status:wd.time_sheet_status} }
      end
    end
    
  end
  
  def update_notification_read
    
    wd = WorkDuration.find(params["wd_id"])
    wd.status_read = false # IF this value is true consultatnt will see notification for status change
    
    if wd.save
      respond_to do |format|
        format.html { redirect_to wd.employee }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to wd.employee }
        format.json { head :no_content }
      end
    end
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_work_duration
  #   @work_duration = WorkDuration.find(params[:id])
  # end

  # Only allow a list of trusted parameters through.
  def work_duration_params
    params.require(:work_duration).permit(:hours, :work_day, :employee_id, :time_card_certify, :company_certify,
                                          :save_for_later, :timesheet_screenshot)
  end
end

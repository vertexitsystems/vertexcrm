class WorkDurationsController < ApplicationController
  # before_action :set_work_duration, only: [:show,:destroy]

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

  def show
    @work_duration = WorkDuration.find(params[:id])
  end

  # POST /work_durations
  # POST /work_durations.json
  def create
    # Today's date %>
    date = Date.today
    date = params['work_duration']['date'].to_datetime if params['work_duration']['date'].present?
    employee = Employee.where(id: params['work_duration']['eid']).first
    time_card_certify = true if params[:time_card_certify] == 'true'
    company_certify = true if params[:company_certify] == 'true'
    save_for_later = params[:save_for_later].present?
    @errors = []
    # First iterate over all the vendors this employee has
    employee.vendors.each do |vendor|
      # Project is the relationship between employee and vendor, also workDuration record is attached to this relationship so we need to fetch it first
      project = employee.projects.where(vendor_id: vendor.id).first
      # Next iterate over all the hours each day has
      (date.at_beginning_of_week..date.at_end_of_week).to_a.take(5).map.each_with_index do |day, index|
        # extract the number of hours for each
        hours_worked = params['work_duration'][%w[a b c d e][index] + project.id.to_s]
        # Try to fetch the work duration object for the day that we are iterating over
        @work_duration = project.work_durations.where(work_day: day).first

        # if we did not find a pre existing work duration create new one else update oldone
        if @work_duration.nil?
          @work_duration = project.work_durations.new(hours: hours_worked, work_day: day,
                                                      time_card_certify: time_card_certify, company_certify: company_certify, save_for_later: save_for_later)
        else
          @work_duration.hours = hours_worked
          @work_duration.time_card_certify = time_card_certify
          @work_duration.company_certify = company_certify
          @work_duration.save_for_later = save_for_later
        end
        @work_duration.time_sheet_status = if save_for_later
                                             'saved'
                                           else
                                             'pending'
                                           end
        @work_duration.timesheet_screenshot = params[:work_duration][:timesheet_screenshot] if day.strftime('%A') == 'Monday'
        @errors << @work_duration.errors.full_messages unless @work_duration.save
      end
    end
    # @work_duration = WorkDuration.new(work_duration_params)
    respond_to do |format|
      if !@errors.present?
        format.html { redirect_to @work_duration.employee, notice: 'Work duration was successfully created.' }
        format.json { render :show, status: :created, location: @work_duration }
      else
        format.html do
          redirect_to { redirect_to @work_duration.employee}
        end
        format.json { render json: @work_duration.errors, status: :unprocessable_entity }
      end
    end
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

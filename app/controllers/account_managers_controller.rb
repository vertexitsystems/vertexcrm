class AccountManagersController < ApplicationController
  before_action :set_account_manager, only: %i[show edit update destroy]
  before_action :check_access, only: [:show, :edit, :update, :destroy, :index, :time_sheet_approval, :reports]
  def check_access
    if !user_signed_in? || !( current_user.is_admin? || current_user.is_account_manager?)
      redirect_to root_path
    end
  end
  # GET /account_managers
  # GET /account_managers.json
  def index
    @account_managers = AccountManager.all
  end

  # GET /account_managers/1
  # GET /account_managers/1.json
  def show; end

  def time_sheet_approval
    # status = { '1' => 'pending', '2' => 'approved', '3' => 'rejected' }
    # unless params[:from_date].present?
    #   @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(
    #     created_at: 3.month.ago.beginning_of_week..Date.today.end_of_day, save_for_later: false
    #   )
    # end
    # if params[:from_date].present?
    #   @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(
    #     created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week, save_for_later: false
    #   )
    # end
    # @work_durations = @work_durations.where(time_sheet_status: status[params[:status_filter]]) if params[:status_filter].present? && @work_durations.present?
    # if @work_durations.present?
    #   @work_durations = @work_durations.group_by do |w|
    #     [w.project.employee.name, w.project.vendor.name, w.project.id,
    #      w.created_at.beginning_of_week]
    #   end
    # end
    #
    @from_date = params[:from_date] if params[:from_date].present?
    @to_date = params[:to_date] if params[:to_date].present?
    @date = @from_date.present? ? "#{@from_date} to #{@to_date}" : 'Date Range'
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def vendor_wise_data
    # status = { '1' => 'pending', '2' => 'approved', '3' => 'rejected' }
#     @from_date = params[:from_date]
#     @to_date = params[:to_date]
#     @status = params[:status_filter]
#     @biweekly = true if params[:biweekly].present?
#     @monthly =  true if params[:monthly].present?
#     @quartarly = true if params[:quartarly].present?
#     @profile_id = Profile.where(full_name: params[:vendor_name]).try(:last).try(:id) if params[:vendor_name].present?
#     if !@from_date.present? && !@biweekly && !@monthly && !@quartarly
#       @work_durations = WorkDuration.includes(project: %i[employee
#                                                           vendor]).where(created_at: 3.month.ago.beginning_of_week..Date.today.end_of_day)
#     end
#     if !@from_date.present? && @biweekly.present?
#       @work_durations = WorkDuration.includes(project: %i[employee
#                                                           vendor]).where(created_at: 2.week.ago.beginning_of_week..Date.today.end_of_day)
#     end
#     if !@from_date.present? && @monthly.present?
#       @work_durations = WorkDuration.includes(project: %i[employee
#                                                           vendor]).where(created_at: 1.month.ago.beginning_of_week..Date.today.end_of_day)
#     end
#     if !@from_date.present? && @quartarly.present?
#       @work_durations = WorkDuration.includes(project: %i[employee
#                                                           vendor]).where(created_at: DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week)
#     end
#     if @from_date.present?
#       @work_durations = WorkDuration.includes(project: %i[employee
#                                                           vendor]).where(created_at: DateTime.parse(@from_date).beginning_of_week..DateTime.parse(@to_date).end_of_week)
#     end
#     if @profile_id.present? && @work_durations.present?
#       @work_durations = @work_durations.where('vendors.profile_id =?',
#                                               @profile_id).references(:vendor)
#     end
#     @work_durations = @work_durations.where(time_sheet_status: status[@status]) if @status.present? && @work_durations.present?
#     if @work_durations.present?
#       @work_durations = @work_durations.group_by do |w|
#         [w.project.employee.name, w.project.vendor.name, w.project.id,
#          w.created_at.beginning_of_week]
#       end
#     end
#     respond_to do |format|
#       format.html
#       format.js
#     end
  end

  def filtered_vendor_report
    status = { '1' => 'pending', '2' => 'approved', '3' => 'rejected' }
    if !params[:from_date].present? && !params[:biweekly].present? && !params[:monthly].present? && !params[:quartarly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 3.month.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:biweekly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 2.week.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:monthly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 1.month.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:quartarly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week)
    end
    if params[:from_date].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week)
    end
    if params[:profile_id].present? && @work_durations.present?
      @work_durations = @work_durations.where('vendors.profile_id =?',
                                              params[:profile_id]).references(:vendor)
    end
    @work_durations = @work_durations.where(time_sheet_status: status[params[:status]]) if params[:status].present? && @work_durations.present?
    if @work_durations.present?
      @work_durations = @work_durations.group_by do |w|
        [w.project.employee.name, w.project.vendor.name, w.project.id,
         w.created_at.beginning_of_week]
      end
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Vendor Wise Report', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, encoding: 'UTF-8', show_as_html: params.key?('debug')
      end
    end
  end

  def send_vendor_email
    params.permit!
    status = { '1' => 'pending', '2' => 'approved', '3' => 'rejected' }
    if !params[:from_date].present? && !params[:biweekly].present? && !params[:monthly].present? && !params[:quartarly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 3.month.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:biweekly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 2.week.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:monthly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: 1.month.ago.beginning_of_week..Date.today.end_of_day)
    end
    if !params[:from_date].present? && params[:quartarly].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week)
    end
    if params[:from_date].present?
      @work_durations = WorkDuration.includes(project: %i[employee
                                                          vendor]).where(created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week)
    end
    if params[:profile_id].present? && @work_durations.present?
      @work_durations = @work_durations.where('vendors.profile_id =?',
                                              params[:profile_id]).references(:vendor)
    end
    @work_durations = @work_durations.where(time_sheet_status: status[params[:status]]) if params[:status].present? && @work_durations.present?
    @data = @work_durations.collect do |w|
      [w.vendor.profile, filtered_vendor_report_account_managers_url(format: 'pdf', params: params)]
    end.uniq
    @data.each do |d|
      VendorMailer.with(profile: d.first, link: d.second).vendor_notification.deliver_now
    end

    respond_to do |format|
      format.html { redirect_to vendor_wise_data_account_managers_url, notice: 'Email sent successfully' }
    end
  end

  def approve_or_reject
    if params[:p_ids].present?
      params[:p_ids].each do |p_work|
        project_duration = eval(p_work)
        @work_durations = Project.find(project_duration.keys.first).work_durations.where(work_day: Date.parse(project_duration.values.first).beginning_of_week..Date.parse(project_duration.values.first).end_of_week)
        if params[:approve].present? && @work_durations.present?
          @work_durations.update_all(time_sheet_status: 'approved')
        end
        if params[:reject].present? && @work_durations.present?
          @work_durations.update_all(time_sheet_status: 'rejected')
        end
      end
    end
    respond_to do |format|
      if @work_durations.present?
        format.html do
          redirect_to time_sheet_approval_account_managers_url, notice: 'TIme Durations Updated successfully'
        end
        format.json { render :show, status: :created, location: @account_manager }
      else
        format.html { redirect_to time_sheet_approval_account_managers_url, notice: 'Nothing to be updated.' }
        format.json { render json: @account_manager.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def timesheet_report
    
  	records_per_page = 10
	
  	page = params[:page].to_i
  	if page.blank?
  		page = 0
  	end
    
  	work_durations = params["eid"].blank? ? WorkDuration.all : Employee.find(params["eid"]).work_durations
	
  	@wds = work_durations.where("extract(dow from work_day) = ?", 1)
	  # 62201AA01 - Start
  	#@wds = @wds.order("work_day DESC") if !params[:order].present? || params[:order] == ""
	
  	#@wds = @wds.order(time_sheet_status: :desc, work_day: :desc) if params[:order].present? && params[:order] == "status"
    
  	#@wds = @wds.joins(:project).order("projects.employee_id DESC") if params[:order].present? && params[:order] == "employee"
  	#@wds = @wds.joins(:project).order("projects.vendor_id DESC") if params[:order].present? && params[:order] == "vendor"
  	#@wds = @wds.joins(:project).order("projects.id DESC") if params[:order].present? && params[:order] == "project"
    # 62201AA01 - End
    
  	@wds = @wds.where("work_day >= ?" , params[:from_date].to_date.beginning_of_week) if params[:from_date].present? && params[:from_date] != ""
  	@wds = @wds.where("work_day <= ?" , params[:to_date].to_date.beginning_of_week) if params[:to_date].present? && params[:to_date] != ""

  	@wds = @wds.joins(:project).where("projects.employee_id = ?" , params[:emp]) if params[:emp].present? && params[:emp] != ""
  	@wds = @wds.joins(:project).where("projects.vendor_id = ?" , params[:vendor]) if params[:vendor].present? && params[:vendor] != ""
  	@wds = @wds.joins(:employee).where("employees.contract_type = ?" , params[:contract]) if params[:contract].present? && params[:contract] != ""
    
  	@total_records = @wds.count
    
    @wds = @wds.order(work_day: :DESC)
    
    #62201AA02
  	#@wds = @wds.limit(records_per_page).offset(page * records_per_page)
    
    # 62201AA04.3
    @employees = (params[:emp].present? && params[:emp] != "") ? [Employee.find(params[:emp].to_i)] : Employee.all
    
    # 62201AA04.1 - START
    @start_date = (params[:to_date].present? && params[:to_date] != "")     ? params[:to_date].to_date : Date.today
    @end_date   = (params[:from_date].present? && params[:from_date] != "") ? params[:from_date].to_date   : (@wds.count > 0 ? @wds.last.work_day.end_of_week : Date.today)
    
    
    @iteration_dates = []
    @start_date.downto(@end_date) do |date|
      if date.monday?
        @iteration_dates << date
      end
    end
    # 62201AA04.1 - END
    
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Weekly TimeSheet', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, 
               encoding: 'UTF-8', 
               show_as_html: params.key?('debug'),
               footer: { :left => 'Vertex IT Systems, Inc', :right => '[page]/[topage]' }
      end
    end
    
  end
  
  def consultant_report
    @consultatnts = Employee.all
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Consultant Report', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, 
               encoding: 'UTF-8', 
               show_as_html: params.key?('debug'),
               footer: { :left => 'Vertex IT Systems, Inc', :right => '[page]/[topage]' }
      end
    end
  end
  
  def jobs_report
    @jobs = Job.all.order(closing_date: :DESC)
    respond_to do |format|
      format.pdf do
        render pdf: 'Jobs Report', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, 
               encoding: 'UTF-8', 
               show_as_html: params.key?('debug'),
               footer: { :left => 'Vertex IT Systems, Inc', :right => '[page]/[topage]' }
      end
    end
  end
  
  # GET /account_managers/new
  def new
    @account_manager = AccountManager.new
    @account_manager.build_profile
  end

  # GET /account_managers/1/edit
  def edit; end

  # POST /account_managers
  # POST /account_managers.json
  def create
    @account_manager = AccountManager.new(account_manager_params)
    
    #@account_manager.build_profile(params[:account_manager][:profile])
    @account_manager.profile.user_type = '7392'
    
    @account_manager.profile.user = User.new(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password])
    
    if !@account_manager.profile.user.save
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @employee.profile.user, status: :unprocessable_entity }
      end
      return
    end
    
    respond_to do |format|
      if @account_manager.save
        format.html { redirect_to @account_manager, notice: 'Account manager was successfully created.' }
        format.json { render :show, status: :created, location: @account_manager }
      else
        format.html { render :new }
        format.json { render json: @account_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_managers/1
  # PATCH/PUT /account_managers/1.json
  def update
    respond_to do |format|
      if @account_manager.update(account_manager_params)
        format.html { redirect_to @account_manager, notice: 'Account manager was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_manager }
      else
        format.html { render :edit }
        format.json { render json: @account_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_managers/1
  # DELETE /account_managers/1.json
  def destroy
    @account_manager.destroy
    respond_to do |format|
      format.html { redirect_to account_managers_url, notice: 'Account manager was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def reports
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account_manager
    @account_manager = AccountManager.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_manager_params
    params.require(:account_manager).permit(:name, :profile_id, :from_date, :to_date, :status_filter, :biweekly, :monthly, :quartarly, :vendor_name, {profile_attributes: [:first_name, :middle_name, :last_name, :phone1, :phone2, :email, :password, :address, :country, :state, :city, :zip_code]})
  end
  
  def user_params
    params[:account_manager][:profile_attributes]
  end
end

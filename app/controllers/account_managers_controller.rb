class AccountManagersController < ApplicationController
  before_action :set_account_manager, only: [:show, :edit, :update, :destroy]

  # GET /account_managers
  # GET /account_managers.json
  def index
    @account_managers = AccountManager.all
  end

  # GET /account_managers/1
  # GET /account_managers/1.json
  def show
  end

  def time_sheet_approval
    status = {"1"=>"pending","2"=>"approved", "3"=>"rejected"}
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:3.month.ago.beginning_of_week..Date.today.end_of_day,save_for_later:false) if !params[:from_date].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week,save_for_later:false) if params[:from_date].present?
    @work_durations = @work_durations.where(time_sheet_status: status[params[:status_filter]]) if params[:status_filter].present? and @work_durations.present?
    @work_durations = @work_durations.group_by{|w| [w.project.employee.name,w.project.vendor.name,w.project.id,w.created_at.beginning_of_week]} if @work_durations.present?
    respond_to do |format|
        format.html
        format.js 
    end
  end

  def vendor_wise_data
    status = {"1"=>"pending","2"=>"approved", "3"=>"rejected"}
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @status = params[:status_filter]
    @biweekly = true if params[:biweekly].present?
    @monthly =  true if params[:monthly].present?
    @quartarly = true if params[:quartarly].present?
    @profile_id = Profile.where(full_name:params[:vendor_name]).try(:last).try(:id) if params[:vendor_name].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:3.month.ago.beginning_of_week..Date.today.end_of_day) if !@from_date.present? and !@biweekly and !@monthly and !@quartarly
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:2.week.ago.beginning_of_week..Date.today.end_of_day) if !@from_date.present? and @biweekly.present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:1.month.ago.beginning_of_week..Date.today.end_of_day) if !@from_date.present? and @monthly.present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week) if !@from_date.present? and @quartarly.present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at: DateTime.parse(@from_date).beginning_of_week..DateTime.parse(@to_date).end_of_week) if @from_date.present?
    @work_durations = @work_durations.where("vendors.profile_id =?",@profile_id).references(:vendor) if @profile_id.present? and @work_durations.present?
    @work_durations = @work_durations.where(time_sheet_status: status[@status]) if @status.present? and @work_durations.present?
    @work_durations = @work_durations.group_by{|w| [w.project.employee.name,w.project.vendor.name,w.project.id,w.created_at.beginning_of_week]} if @work_durations.present?
    respond_to do |format|
        format.html
        format.js 
    end
  end

  def filtered_vendor_report
    status = {"1"=>"pending","2"=>"approved", "3"=>"rejected"}
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:3.month.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and !params[:biweekly].present? and !params[:monthly].present? and !params[:quartarly].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:2.week.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and params[:biweekly].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:1.month.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and params[:monthly].present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week) if !params[:from_date].present? and params[:quartarly].present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week) if params[:from_date].present?
    @work_durations = @work_durations.where("vendors.profile_id =?",params[:profile_id]).references(:vendor) if params[:profile_id].present? and @work_durations.present?
    @work_durations = @work_durations.where(time_sheet_status: status[params[:status]]) if params[:status].present? and @work_durations.present?
    @work_durations = @work_durations.group_by{|w| [w.project.employee.name,w.project.vendor.name,w.project.id,w.created_at.beginning_of_week]} if @work_durations.present?
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Vendor Wise Report" , page_size: 'A4',margin: {top: '10mm', bottom: '10mm', left: '5mm', right: '5mm'}, encoding: 'UTF-8',show_as_html: params.key?('debug')
      end
    end
  end


  def send_vendor_email
    params.permit!    
    status = {"1"=>"pending","2"=>"approved", "3"=>"rejected"}
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:3.month.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and !params[:biweekly].present? and !params[:monthly].present? and !params[:quartarly].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:2.week.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and params[:biweekly].present?
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:1.month.ago.beginning_of_week..Date.today.end_of_day) if !params[:from_date].present? and params[:monthly].present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at:DateTime.now.beginning_of_year.beginning_of_week..(DateTime.now.beginning_of_year.beginning_of_week + 16.week).beginning_of_week) if !params[:from_date].present? and params[:quartarly].present? 
    @work_durations = WorkDuration.includes(project:[:employee,:vendor]).where(created_at: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week) if params[:from_date].present?
    @work_durations = @work_durations.where("vendors.profile_id =?",params[:profile_id]).references(:vendor) if params[:profile_id].present? and @work_durations.present?
    @work_durations = @work_durations.where(time_sheet_status: status[params[:status]]) if params[:status].present? and @work_durations.present?
    @data = @work_durations.collect{|w| [w.vendor.profile,filtered_vendor_report_account_managers_url(format: "pdf",params:params)]}.uniq
    @data.each do |d|
      VendorMailer.with(profile:d.first,link:d.second).vendor_notification.deliver_now
    end
    
    respond_to do |format|
      format.html { redirect_to vendor_wise_data_account_managers_url, notice: 'Email sent successfully'}
    end 
  end
  def approve_or_reject
    @projects = Project.where(id:params[:p_ids]).joins(:work_durations).where("work_durations.time_sheet_status = ? AND work_durations.save_for_later=? ",0,false) if params[:p_ids].present?
    if params[:approve].present? and @projects.present?
      @projects.uniq.each{|p| p.work_durations.update_all(time_sheet_status:"approved")}
    elsif params[:reject].present? and @projects.present?
      @projects.uniq.each{|p| p.work_durations.update_all(time_sheet_status:"rejected")}
    end

    respond_to do |format|
      if @projects.present?
        format.html { redirect_to time_sheet_approval_account_managers_url, notice: 'TIme Durations Updated successfully'}
        format.json { render :show, status: :created, location: @account_manager }
      else
        format.html { redirect_to time_sheet_approval_account_managers_url, notice: 'Nothing to be updated.'} 
        format.json { render json: @account_manager.errors, status: :unprocessable_entity }
      end
    end 
  end

  # GET /account_managers/new
  def new
    @account_manager = AccountManager.new
  end

  # GET /account_managers/1/edit
  def edit
  end

  # POST /account_managers
  # POST /account_managers.json
  def create
    @account_manager = AccountManager.new(account_manager_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_manager
      @account_manager = AccountManager.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_manager_params
      params.require(:account_manager).permit(:name, :profile_id, :from_date,:to_date,:status_filter,:biweekly,:monthly,:quartarly,:vendor_name)
    end
end

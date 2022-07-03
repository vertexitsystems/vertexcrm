class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.joins(:profile).order("profiles.full_name")
    
    params.each do |key, value|
      if key == "emp"
        @employees = @employees.select{|emp|emp.id == value.to_i}
      end
      if key == "proj"
        @employees = @employees.select{|emp|!emp.projects.blank? && emp.projects.first.id == value.to_i}
      end
      if key == "contract"
        @employees = @employees.select{|emp|emp.contract_type == value}
      end
      if key == "vendor"
        @employees = @employees.select{|emp|!emp.projects.blank? && emp.projects.first.vendor.id == value.to_i}
      end
    end
  end

  # GET //employees/dashboard
  def dashboard
    @profile = current_user.profile
    
    # Dashboard will not be accesible to anyone but the owner employee so there is no need to check if current_user is same or not
    # IF logged in user has no employee object associated with it create one
    if @profile.employee.blank?
      Employee.new(profile_id: @profile.id).save
      #@profile.create_employee()
    end
    
    
    @employee = @profile.employee
    #if current_user.is_employee? && !current_user.profile.employee.blank?
    #  @employee = current_user.profile.employee
    #else
    #  redirect_to root_path
    #end
    
  end
  
  # GET /employees/1
  # GET /employees/1.json
  def show
    # Make sure the page is being accessed by those who have the rights to view this page
    if !(current_user.is_admin? || current_user.is_account_manager? || current_user.profile.id.to_i == @employee.profile.id.to_i) 
      flash[:alert] = "Access Denied"
      redirect_to root_path
    end
    
    # Make sure the employee does not see data that they arent suppose to by applying filters 
    if current_user.is_employee? && params[:emp].present?
      flash[:alert] = "Access Denied: Bad Filter"
      redirect_to root_path
    end
    
    # Make sure when employee accesses this page they have work_durations for current and previous week
    
    @employee.vendors.each do |vendor|
      project = @employee.projects.where(vendor_id: vendor.id).first
      last_week_date = Date.today - Date.today.wday
      (last_week_date.at_beginning_of_week..Date.today.at_end_of_week).to_a.map.each_with_index do |day, _index|
        day_entry = project.work_durations.where(work_day: day)
        project.work_durations.create(hours: 0, work_day: day, time_sheet_status:1) unless day_entry.present?
      end
    end
    
    # unless params[:from_date].present?
#       @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(work_day: 3.month.ago.beginning_of_week..Date.today.end_of_week).where(
#         'projects.employee_id =?', @employee.id
#       ).references(:project)
#     end
#     if params[:from_date].present?
#       @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(work_day: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week).where(
#         'projects.employee_id =?', @employee.id
#       ).references(:project)
#     end
#     if @work_durations.present?
#       @work_durations = @work_durations.order(work_day: :desc).group_by do |w|
#         [w.project.employee.name, w.project.vendor.name, w.project.id,
#          w.work_day.beginning_of_week]
#       end
#     end
#     @from_date = params[:from_date] if params[:from_date].present?
#     @to_date = params[:to_date] if params[:to_date].present?
#     @date = @from_date.present? ? "#{@from_date} to #{@to_date}" : 'Date Range'
    respond_to do |format|
      format.html
      format.js
    end
  end

  def employee_report
    @employee = Employee.find(params[:eid])
                     
    @work_durations = @employee.work_durations
    @work_durations = @work_durations.where(work_day: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week) if params[:from_date].present?
    @work_durations = @work_durations.includes(project: [:employee]).group_by do |w|
       [w.project.employee.name, w.work_day.beginning_of_week]
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Employee Wise Report', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, 
               encoding: 'UTF-8', 
               show_as_html: params.key?('debug')
      end
    end
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @employee.build_profile
  end

  # GET /employees/1/edit
  def edit
    if !(current_user.is_admin? || current_user.is_account_manager?)
      redirect_to edit_profile_path(current_user.profile)
    end
  end

  def add_vendor; end

  # POST /employees
  # POST /employees.json
  def create
    
    @employee = Employee.new(employee_params)
    @employee.profile.user_type = '445'
    
    @employee.profile.user = User.new(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password])
    
    if !@employee.profile.user.save
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @employee.profile.user, status: :unprocessable_entity }
      end
      return
    end
    
    respond_to do |format|
      if @employee.save
        
        @employee.projects << Project.create(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
        
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    #byebug
    respond_to do |format|
      #print "=================> " + employee_params.except("profile_attributes").except("id").to_s
      #byebug
      if @employee.update(employee_params.except("profile_attributes").except("id"))
        if @employee.profile.update(employee_params["profile_attributes"])

          if @employee.projects.count > 0
            if @employee.projects.first.update(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
              format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
              format.json { render :show, status: :ok, location: @employee }
            else
              format.html { render :edit }
              format.json { render json: @employee.projects.errors, status: :unprocessable_entity }
            end
          else
            @employee.projects << Project.create(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
            format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
            format.json { render :show, status: :ok, location: @employee }
          end
          
        else
          format.html { render :edit }
          format.json { render json: @employee.profile.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def disable_consultant
    @employee = Employee.find(params["emp_id"])
    
    if @employee.update(:disabled=>true, :disable_reason=>params["disable_reason"], :disable_date=>params["disable_date"], :disable_notes=>params["disable_notes"])
      render json: {result:true}
    else
      print "----> " + @employee.errors.full_messages.to_sentence
      render json: {result:false,error:@employee.errors}
    end
    
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.require(:employee).except("vendor").except("vendor_rate").except("employee_rate").except("email").except("password").permit(:rate, :vendor_id, :name, :email, :password, :passport, :visa, :state_id, :i9, :e_verify, :w9, :psa, :voided_check_copy, :client_id, :employer_id, :contract_type,:visa_status,:visa_expiry,:disabled,:disable_reason,:disable_date,:disable_notes, :employer_rate, :job_id, {profile_attributes: [:first_name, :middle_name, :last_name, :phone1, :phone2, :email, :password, :address, :country, :state, :city, :zip_code]})
  end
  
  def user_params
    params[:employee][:profile_attributes]
  end
end
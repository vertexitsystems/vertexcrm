class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /employees
  # GET /employees.json
  def index
    if current_user.is_employee?
      redirect_to root_path
    end
    
    #@employees = Employee.joins(:profile).order("profiles.full_name").includes(:profile, :jobs, :vendors)
    @employees = Employee.order(disabled: :desc, created_at: :desc)#.includes(:profile, :job, :vendors)

    @employees = @employees.where(id: params[:emp]) if params[:emp].present? && !params[:emp].blank?
    @employees = @employees.where('job_id = ?', params[:proj]) if params[:proj].present? && !params[:proj].blank?
    @employees = @employees.where(contract_type: params[:contract]) if params[:contract].present? && !params[:contract].blank?
    @employees = @employees.where('vendors.id = ?', params[:vendor]) if params[:vendor].present? && !params[:vendor].blank?
    
    @employees = @employees.page(params[:page])
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
    
    respond_to do |format|
      format.html
      format.json { render json: @employee }
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
        
        #@employee.projects << Project.create(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
        
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
    
    @user = @employee.profile.user
    
    respond_to do |format|
      
      if @employee.update(employee_params.except("profile_attributes").except("id"))
        
        if params[:employee][:profile_attributes][:password].present? && !params[:employee][:profile_attributes][:password].blank?
          user_updated = @user.update(email: params[:employee][:profile_attributes][:email], password: params[:employee][:profile_attributes][:password])
        elsif params[:employee][:profile_attributes][:email].present? && !params[:employee][:profile_attributes][:email].blank? && (params[:employee][:profile_attributes][:password] != @user.email)
          user_updated = @user.update(email: params[:employee][:profile_attributes][:email])
        end
        
        if user_updated
          format.html { redirect_to @employee.profile, notice: "Consultant was successfully updated." }
          format.json { render :show, status: :ok, location: @employee }
        else
          flash[:alert] = "Failed with error: #{@user.errors.full_messages}"
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      
      end
    end

    #byebug
    # respond_to do |format|
    #   #print "=================> " + employee_params.except("profile_attributes").except("id").to_s
    #   #byebug
    #   if @employee.update(employee_params.except("profile_attributes").except("id"))
    #     if @employee.profile.update(employee_params["profile_attributes"])

    #       if @employee.projects.count > 0
    #         if @employee.projects.first.update(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
    #           format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
    #           format.json { render :show, status: :ok, location: @employee }
    #         else
    #           format.html { render :edit }
    #           format.json { render json: @employee.projects.errors, status: :unprocessable_entity }
    #         end
    #       else
    #         @employee.projects << Project.create(vendor_id:params["employee"]["vendor"], vendor_rate:params["employee"]["vendor_rate"], rate:params["employee"]["employee_rate"])
    #         format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
    #         format.json { render :show, status: :ok, location: @employee }
    #       end
          
    #     else
    #       format.html { render :edit }
    #       format.json { render json: @employee.profile.errors, status: :unprocessable_entity }
    #     end
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @employee.errors, status: :unprocessable_entity }
    #   end
    # end
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
  
  # MARK - Custom Methods
  
  # GET //employees/dashboard
  def dashboard
    @employee = current_user.profile.employee
    
    # Dashboard will not be accesible to anyone but the owner employee so there is no need to check if current_user is same or not
    # IF logged in user has no employee object associated with it create one
    if @employee.blank?
      if Employee.new(profile_id: @profile.id).save
        @employee = current_user.profile.employee
      else
      end
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
  def add_vendor; end
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
    params.require(:employee).except("vendor").except("vendor_rate").except("employee_rate").except("email").except("password").permit(:rate, :vendor_id, :name, :email, :password, :passport, :visa, :state_id, :i9, :e_verify, :w9, :psa, :voided_check_copy, :client_id, :employer_id, :contract_type,:visa_status,:visa_expiry,:disabled,:disable_reason,:disable_date,:disable_notes, :employer_rate, :job_id, :job_start_date, :resume, :new_hire_package, :po, :w2_contract, :offer_letter, :w4, :direct_deposit_detail, :emergency_contact_form, {profile_attributes: [:first_name, :middle_name, :last_name, :phone1, :phone2, :email, :password, :address, :country, :state, :city, :zip_code]})
  end
  
  
      
  def user_params
    params[:employee][:profile_attributes]
  end
end
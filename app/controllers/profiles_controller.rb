class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :has_admin_access?, only: [:index, :new, :create, :destroy]
  
  include ActionView::Helpers::UrlHelper
  
  # GET /profiles
  # GET /profiles.json
  def index
    
    #profiles/?drop_all=1
    if params[:drop_all].present?
      Profile.destroy_all
      User.destroy_all
      AccountManager.destroy_all
      Client.destroy_all
      Employee.destroy_all
      Employer.destroy_all
      Invoice.destroy_all
      JobApplication.destroy_all
      JobPost.destroy_all
      Job.destroy_all
      Project.destroy_all
      Timesheet.destroy_all
      Vendor.destroy_all
      WorkDuration.destroy_all
    end
    
    @profiles = Profile.all
  end
  
  # GET /profiles/1
  # GET /profiles/1.json
  def show
    
    
    if user_signed_in?
      if current_user.profile.nil?
        current_user.profile = Profile.create(full_name: '', user_type: current_user.email == 'dev@vertexitsystems.com' ? 357_168 : 0)
        current_user.save
      end
      
      if params[:update_type].present?
        # for admin
        if current_user.profile.update(user_type:params[:update_type])
          redirect_to root_path
        end
      end
      
      #@profile = Profile#current_user.profile
      
      # when logging in profile id will not be passed so profile is set to current_user automatically
      if @profile.blank?
        @profile = current_user.profile
      end
      
      # Fail safe to ensure profile has user
      # TEST WITH: http://localhost:3000/profiles/11
      if @profile.user.blank?
        flash[:alert] = 'Profile not linked to any user'
        redirect_to root_path
      end
      
      if !@profile.user_type.blank?
        case @profile.user_type
          when 357_168 # Admin

          when 3396 # Employer
            redirect_to employer_url(@profile.employer.id)
          when 445 # Employee
            

            if !@profile.employee.blank?
              if @profile.employee.disabled && @profile.id == current_user.profile.id
                flash[:alert] = "This account has been disabled."
                sign_out(current_user)
                redirect_to new_user_session_url
                return
              end
            end

            if current_page?('/')
              redirect_to dashboard_employees_path
            end

          when 2623 # Vendor
            #redirect_to vendor_url(@profile.vendor.id)
          else
            puts 'Wrong type'
        end
      else
        if !@profile.employee.blank?
          if @profile.employee.disabled && @profile.id == current_user.profile.id
            flash[:alert] = "This account has been disabled."
            sign_out(current_user)
            redirect_to new_user_session_url
          end
        end
      end

    else
      redirect_to new_user_session_url
    end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    if @profile.id != current_user.profile.id
      if !(current_user.is_admin? || current_user.is_account_manager?)
        redirect_to edit_profile_path(current_user.profile)
      end
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.create(profile_params)
    @user = User.new(email: params[:profile][:email], password: params[:profile][:password],
                     password_confirmation: params[:profile][:password])
    if @user.save
      puts 'USER created'
    else
      puts 'USER NOT created' + @user.errors.messages.to_s
      
      # respond_to do |format|
      #  return format.html { render :new }
      # end
    end
    
    @profile.user = @user if @user.errors.messages.blank?
    respond_to do |format|
      if @user.errors.messages.blank? && @profile.save
        case params[:profile][:user_type].to_i
        when 357_168 # Admin
          puts 'Admin Not Created'
        when 3396 # Employer
          puts 'Employer Not Created'
        when 445 # Employee
          @employee = Employee.create
          @employee.profile = @profile
          if @employee.save
            unless params[:profile][:vendor_id].blank?
              Project.create(vendor_id: params[:profile][:vendor_id], rate: params[:profile][:rate],
                             employee_id: @employee.id)
            end
            puts 'Employee Created'
            format.html { redirect_to employee_edit_path(@profile.employee), notice: 'Profile was successfully created.' }
            format.json { render :show, status: :created, location: @profile }
            return
          else
            puts 'Employee NOT created' + @employee.errors.messages.to_s
          end

        when 2623 # Vendor

          @vendor = Vendor.create
          @vendor.profile = @profile

          if @vendor.save
            puts 'Vendor Created'
          else
            puts 'Vendor NOT created' + @employee.errors.messages.to_s
          end
        when 7392 # Account manager
          @account_manager = AccountManager.create
          @account_manager.profile = @profile
          if @account_manager.save
            puts 'Account Manager Created'
          else
            puts 'Account Manager NOT created' + @account_manager.errors.messages.to_s
          end
        when 3396
          @employer = Employer.create
          @employer.profile = @profile
          if @employer.save
            puts 'Employer created'
          else
            puts 'Employer NOT created' + @employer.errors.full_messages.to_s
          end
        when 6532
          @assistant = Assistant.create
          @assistant.profile = @profile
          if @assistant.save
            puts 'assistant created'
          else
            puts 'assistant NOT created' + @assistant.errors.full_messages.to_s
          end
        else
          puts 'Other Not Created' + params[:profile][:user_type].to_s
        end

        format.html { redirect_to root_path, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, local: { role: 'employee' } }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    # unless params[:profile][:vendor_id].blank?
    #   Project.create(vendor_id: params[:profile][:vendor_id], rate: params[:profile][:rate],
    #                  employee_id: @profile&.employee&.id)
    # end
    
    respond_to do |format|
      
      if @profile.update(profile_params)
        
        if params[:profile][:password].present? && !params[:profile][:password].blank?
          user_updated = @profile.user.update(email: params[:profile][:email], password: params[:profile][:password])
        elsif params[:profile][:email].present? && !params[:profile][:email].blank? && (params[:profile][:password] != @profile.email)
          user_updated = @profile.user.update(email: params[:profile][:email])
        end
        
        if user_updated
          format.html { redirect_to root_path, notice: "Consultant was successfully updated." }
          format.json { render :show, status: :ok, location: @profile }
        else
          flash[:alert] = "Failed with error: #{@profile.errors.full_messages}"
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
        
        #format.html { redirect_to profile_path(@profile), notice: 'Profile was successfully updated.' }
        #format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_user
    @user = User.find(params[:user_id])
    
    if @user.destroy
      redirect_to profiles_url, notice: "User deleted."
    end
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id]) unless params[:id].nil?
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:full_name, :user_type, :email, :password, :phone1, :phone2, :address, :photo, :resume, :degree, :country, :state, :city, :zip_code, :first_name, :middle_name, :last_name)
  end
end

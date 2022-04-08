class EmployersController < ApplicationController
  before_action :set_employer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :has_admin_access?, only: [:index, :new, :edit, :create, :update, :destroy]
  
  # GET /employers
  # GET /employers.json
  def index
    @employers = Employer.all
  end

  # GET /employers/1
  # GET /employers/1.json
  def show
    @invoice = Invoice.new
  end

  # GET /employers/new
  def new
    @employer = Employer.new
    @employer.build_profile
  end

  # GET /employers/1/edit
  def edit
    if @employer.profile.blank?
      @employer.build_profile
    end
  end

  # POST /employers
  # POST /employers.json
  def create
    
    @employer = Employer.new(employer_params)
    @employer.profile.user_type = '3396'
    
    @employer.profile.user = User.new(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password])
    
    if !@employer.profile.user.save
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @employer.profile.user, status: :unprocessable_entity }
      end
      return
    end
    
    respond_to do |format|
      if @employer.save
        
        format.html { redirect_to @employer, notice: 'Employer was successfully created.' }
        format.json { render :show, status: :created, location: @employer }
      else
        format.html { render :new }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
    
    
    
    # OLD
    
    # @employer = Employer.new(employer_params)
    #
    # respond_to do |format|
    #   if @employer.save
    #     format.html { redirect_to @employer, notice: 'Employer was successfully created.' }
    #     format.json { render :show, status: :created, location: @employer }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @employer.errors, status: :unprocessable_entity }
    #   end
    # end
    
  end

  # PATCH/PUT /employers/1
  # PATCH/PUT /employers/1.json
  def update
    respond_to do |format|
      if @employer.update(employer_params.except("profile_attributes").except("id"))
        if @employer.profile.update(employer_params["profile_attributes"])
          format.html { redirect_to @employer, notice: 'Employer was successfully updated.' }
          format.json { render :show, status: :ok, location: @employer }
        else
          format.html { render :edit }
          format.json { render json: @employer.errors, status: :unprocessable_entity }
        end  
      else
        format.html { render :edit }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employers/1
  # DELETE /employers/1.json
  def destroy
    @employer.destroy
    respond_to do |format|
      format.html { redirect_to employers_url, notice: 'Employer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employer
      @employer = Employer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employer_params
      params.require(:employer).permit(:company_name, :company_address, :phone_number, :fax_number, :company_email, :company_website, :contact_name, :contact_designation, :contact_number, :contact_email, {profile_attributes: [:first_name, :middle_name, :last_name, :phone1, :phone2, :email, :password, :address, :country, :state, :city, :zip_code]})#.permit(:company_name, :profile_id)
    end
    
    def user_params
      params[:employer][:profile_attributes]
    end
end

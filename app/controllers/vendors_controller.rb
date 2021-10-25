class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # GET /vendors
  # GET /vendors.json
  def index
    case current_user.profile.role
    when "Admin"
      @vendors = Vendor.all
    when "Employee"
      @vendors = current_user.profile.employee.vendors
    else
      @vendors = Vendor.all
    end
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
  end
  def vendor_wise_report
    @project_ids = Project.where(vendor_id:params[:vendor_id]).ids
    @work_durations = WorkDuration.includes(project:[:employee]).group_by{|w| [w.project.employee.name,w.created_at.beginning_of_week]}
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Vendor Wise Report" , page_size: 'A4',margin: {top: '10mm', bottom: '10mm', left: '5mm', right: '5mm'}, encoding: 'UTF-8',show_as_html: params.key?('debug')
      end
    end
  end
  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to @vendor, notice: 'Vendor was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1
  # PATCH/PUT /vendors/1.json
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to @vendor, notice: 'Vendor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: 'Vendor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:name)
    end
end

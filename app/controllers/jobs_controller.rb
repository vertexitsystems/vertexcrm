class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :has_admin_access?, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  
  # GET /jobs or /jobs.json
  def index
    records_per_page = 10
    
  	@page = (!params[:page].present? || params[:page] == "") ? 0 : params[:page]
    
    @jobs = Job.all
    
    #@jobs = @jobs.order("created_at DESC") if !params[:order].present? || params[:order] == ""
    #@jobs = @jobs.order(:status) if params[:order].present? && params[:order] == "status"
    
    @jobs = @jobs.where("start_date >= ?" , params[:from_date].to_date) if params[:from_date].present? && params[:from_date] != ""
    @jobs = @jobs.where("start_date <= ?" , params[:to_date].to_date) if params[:to_date].present? && params[:to_date] != ""
    
    @jobs = @jobs.where(params[:status] != "Open" ? "closing_date IS NOT NULL" : "closing_date IS NULL") if params[:status].present? && params[:status] != ""
    @jobs = @jobs.where("vendor_id = ?" , params[:vendor]) if params[:vendor].present? && params[:vendor] != ""
    @jobs = @jobs.where("client_id = ?" , params[:client]) if params[:client].present? && params[:client] != ""
    
    @jobs = @jobs.limit(records_per_page).offset(@page * records_per_page)
    
    
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def disable_job
    @job = Job.find(params["job_id"])
    
    if @job.update(:closing_remarks=>params["disable_reason"], :closing_date=>params["disable_date"])
      render json: {result:true}
    else
      print "----> " + @job.errors.full_messages.to_sentence
      render json: {result:false,error:@job.errors}
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:start_date,:end_date,:title,:rate,:job_description,:location,:job_type,:closing_date,:closing_remarks,:vendor_id,:client_id)
    end
end



class PostingsController < ApplicationController
  before_action :set_posting, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :has_admin_access?, only: [:index, :new, :edit, :create, :update, :destroy, :show, :index]
  
  # GET /postings or /postings.json
  def index
    @postings = Posting.all
  end

  # GET /postings/1 or /postings/1.json
  def show
  end

  # GET /postings/new
  def new
    @posting = Posting.new
    @job = Job.find(params[:job_id]) unless params[:job_id].blank?
  end

  # GET /postings/1/edit
  def edit
    @job = @posting.job
  end

  # POST /postings or /postings.json
  def create
    
    @posting = Posting.new(posting_params)
    respond_to do |format|
      if @posting.save
        format.html { redirect_to @posting.job, notice: "Posting was successfully created." }
        format.json { render :show, status: :created, location: @posting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postings/1 or /postings/1.json
  def update
    respond_to do |format|
      if @posting.update(posting_params)
        format.html { redirect_to @posting.job, notice: "Posting was successfully updated." }
        format.json { render :show, status: :ok, location: @posting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1 or /postings/1.json
  def destroy
    @posting.destroy
    respond_to do |format|
      format.html { redirect_to postings_url, notice: "Posting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_posting
      @posting = Posting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def posting_params
      params.fetch(:posting, {}).permit(:start_date, :end_date, :job_id, :employee_id)
    end
end

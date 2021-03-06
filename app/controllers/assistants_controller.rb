class AssistantsController < ApplicationController
  before_action :set_assistant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :has_admin_access?, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  
  # GET /assistants
  # GET /assistants.json
  def index
    @assistants = Assistant.all
  end

  # GET /assistants/1
  # GET /assistants/1.json
  def show
  end

  # GET /assistants/new
  def new
    @assistant = Assistant.new
  end

  # GET /assistants/1/edit
  def edit
  end

  # POST /assistants
  # POST /assistants.json
  def create
    @assistant = Assistant.new(assistant_params)

    respond_to do |format|
      if @assistant.save
        format.html { redirect_to @assistant, notice: 'Assistant was successfully created.' }
        format.json { render :show, status: :created, location: @assistant }
      else
        format.html { render :new }
        format.json { render json: @assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assistants/1
  # PATCH/PUT /assistants/1.json
  def update
    respond_to do |format|
      if @assistant.update(assistant_params)
        format.html { redirect_to @assistant, notice: 'Assistant was successfully updated.' }
        format.json { render :show, status: :ok, location: @assistant }
      else
        format.html { render :edit }
        format.json { render json: @assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assistants/1
  # DELETE /assistants/1.json
  def destroy
    @assistant.destroy
    respond_to do |format|
      format.html { redirect_to assistants_url, notice: 'Assistant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assistant
      @assistant = Assistant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assistant_params
      params.require(:assistant).permit(:name, :profile_id)
    end
end

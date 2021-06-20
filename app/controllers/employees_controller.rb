class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    if !WorkDuration.where(work_day: Date.today.beginning_of_week).present?
      @employee.vendors.each do |vendor|
        project = @employee.projects.where(vendor_id: vendor.id).first
        (Date.today.at_beginning_of_week..Date.today.at_end_of_week).to_a.take(5).map.each_with_index do |day, _index|
          project.work_durations.create(hours: 0, work_day: day)
        end
      end
    end
    unless params[:from_date].present?
      @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(work_day: 3.month.ago.beginning_of_week..Date.today.end_of_week).where(
        'projects.employee_id =?', @employee.id
      ).references(:project)
    end
    if params[:from_date].present?
      @work_durations = WorkDuration.includes(project: %i[employee vendor]).where(work_day: DateTime.parse(params[:from_date]).beginning_of_week..DateTime.parse(params[:to_date]).end_of_week).where(
        'projects.employee_id =?', @employee.id
      ).references(:project)
    end
    if @work_durations.present?
      @work_durations = @work_durations.order(work_day: :desc).group_by do |w|
        [w.project.employee.name, w.project.vendor.name, w.project.id,
         w.work_day.beginning_of_week]
      end
    end
    @from_date = params[:from_date] if params[:from_date].present?
    @to_date = params[:to_date] if params[:to_date].present?
    @date = @from_date.present? ? "#{@from_date} to #{@to_date}" : 'Date Range'
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
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, encoding: 'UTF-8', show_as_html: params.key?('debug')
      end
    end
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit; end

  def add_vendor; end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    respond_to do |format|
      if @employee.save
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
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.require(:employee).permit(:rate, :vendor_id, :name, :email, :password)
  end
end

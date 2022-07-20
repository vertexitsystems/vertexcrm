class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]

  
  DateRange = Struct.new(:s, :e)
  
  # GET /invoices or /invoices.json
  def index
    if current_user.is_admin? || current_user.is_account_manager?
      @invoices = Invoice.where.not(payment_date: nil)
    elsif current_user.is_employer? && params[:emp].present?
      @employee = Employee.find(params[:emp].to_i)
      @employer = current_user.profile.employer
      if !@employee.blank? && @employee.employer.id == current_user.profile.employer.id
        @invoices = @employee.invoices.where(employer_id: current_user.profile.employer.id)
        #Invoice.where(employee_id: current_user.profile.employer.id, employer_id: current_user.profile.employer.id)
      else
        flash[:alert] = "Access Denied"
        redirect_to root_path
      end
    else
      flash[:alert] = "Access Denied"
      redirect_to root_path
    end
    
    
    
    start_date = Date.today
    @date_ranges = []
    (0...10).each do |index|
      start_date = (start_date.day > 15) ? start_date.end_of_month : (start_date.beginning_of_month + 14)
      end_date = (start_date.day > 15) ? start_date.change(:day => 16) : start_date.beginning_of_month#(start_date - 14)
      
      
      range  = DateRange.new start_date, end_date
      
      @date_ranges.append( range )
      
      start_date = end_date.last_week
    end
    
    
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    if @invoice.blank?
      if params[:emp].present? && params[:elr].present? && params[:s].present?
        employee = Employee.find(params[:emp]) if Employee.where(id: params[:emp]).count > 0
        employer = Employer.find(params[:elr]) if Employer.where(id: params[:elr]).count > 0
        
        begin
           start_date = Date.parse(params[:s])
        rescue ArgumentError
          flash[:alert] = "Invoice Not Found"
          redirect_to root_path
        end
        
        
        
        if !employee.blank? && !employer.blank?
          
          @invoice = Invoice.new(employee_id: employee.id, employer_id:employer.id, payment_date: start_date)
          
        else
          flash[:alert] = "Invoice Not Found"
          redirect_to root_path
        end
        
      else
        flash[:alert] = "Invoice Not Found"
        redirect_to root_path
      end
    end
    
    
    
  end

  # GET /invoices/new
  def new
    if params[:emp].present? && params[:elr].present? && params[:s].present?
      @invoice = Invoice.new(employee_id: params[:emp].to_i, employer_id: params[:elr].to_i, payment_date: params[:s].to_date)
    else
      flash[:alert] = "Parameters missing: emp, elr, s"
      redirect_to invoices_path
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # MARK: Custom Methods
  
  def update_status
    if !(current_user.is_admin? || current_user.is_account_manager?)
      flash[:notice] = "Only Account managers and Admins can perform this action"
      redirect_to invoices_path
    else
      invoice = Invoice.find(params["invoice_id"])
      if params["payment_status"] == "O"  # Reopen
        if invoice.update(:approval_status => 2)#invoice.update(:payment_status => false, :payment_rejection_message => nil)
          flash[:notice] = "Updated Invoice status"
          redirect_to invoices_path
        end
      else
        
        #elsif invoice.update(:payment_status => (params["payment_status"] == "1"), :payment_rejection_message => (params["payment_status"] == "0") ? "Unable to verify validity" : "")
        if invoice.update(approval_status: params["payment_status"] == "1" ? 3 : 4)
          flash[:notice] = "Updated Invoice status"
          redirect_to invoices_path
        
        else
          flash[:notice] = "Failed to update Status"
          redirect_to invoices_path
        end
      end
    end
    
  end
  
  # This method generates a new invoice to be delivered to the client
  def create_new_invoice
    @client = params[:client_id].present? ? Client.find(params[:client_id]) : Client.first
  end
  
  def json_employee_info
    
    if !params[:eid].present? || !params[:start].present? || !params[:end].present?
      respond_to do |format|
        format.html { redirect_to :back, alert: "This method cannot be called as an html request." }
        format.json { render json: {result:false, id: nil, status:"Error: Wrong Parameters"} }
      end
      return
    end

    employee   = Employee.includes(:profile).find(params[:eid])
    start_date = params[:start].to_date
    end_date   = params[:end].to_date
    
    if employee.blank? || start_date.blank? || end_date.blank?
      respond_to do |format|
        format.html { redirect_to :back, alert: "This method cannot be called as an html request." }
        format.json { render json: {result:true, id: nil, status:"Error: Bad Parameter Values"} }
      end
      return
    end
    
    wds = employee.work_durations.where(work_day: start_date...end_date)
    hours_quantity = wds.map{|wd|wd.fetch_hours_array.filter{|h|h > 0}.count}.inject(:+).to_i
    rate = employee.jobs.count > 0 ? employee.jobs.first.rate.to_i : 0
    
    respond_to do |format|
      format.html { redirect_to :back, alert: "This method cannot be called as an html request." }
      format.json { render json: {result:true,
                                  emp_name: employee.profile.name, 
                                  emp_id: employee.id,
                                  start_date:start_date,
                                  end_date:end_date,
                                  id: employee.id,
                                  quantity: hours_quantity,
                                  rate: rate,
                                  designation: wds.first.blank? ? "" : (wds.first.posting.blank? ? "" : wds.first.posting.designation),
                                  status:"success"
                                }
                              }
    end
  end
  
  def generate_invoice
    
    @client = Client.find(params[:client]) if params[:client].present?
    @values = params[:employees].blank? ? [] : params[:employees].to_unsafe_h.values

    @employees = Employee.includes(:profile).where(id: @values.map{|e|e["emp_id"].to_i}) if params[:employees].present? && !params[:employees].blank?

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Invoice Report', page_size: 'A4',
               margin: { top: '10mm', bottom: '10mm', left: '5mm', right: '5mm' }, 
               encoding: 'UTF-8', 
               show_as_html: params.key?('debug')
      end
    end
    
  end
  
  def generate_invoice_pdf
    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id]) if Invoice.where(id: params[:id]).count > 0
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:invoice_file, :employee_id, :employer_id, :payment_date, :payment_status, :payment_rejection_message, :approval_status)
    end
end

class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @filtered = ['company']
    @contracts = @company.contracts
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html {
          redirect_to redirect_link(company_id: @company.id) ||@company, notice: t('company.successfully_created')
        }
        format.json { render action: 'show', status: :created, location: @company }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: t('company.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  def bulk_edit
    @company = Company.find(params[:id])
    month = DateTime.now.month
    year = DateTime.now.year
    params[:date]||= { year: year, month: month }
    @payments = @company.payments.where(month: params[:date][:month], year: params[:date][:year])
    actual_payments_employee_ids = @payments.map do |p| p.employee.id end
    new_payments = @company.employees.map do |e|
      Payment.new(employee: e, month: month, year: year, amount: 0) unless
          actual_payments_employee_ids.include? e.id
    end.compact
    @payments = @payments + new_payments
  end

  def bulk_save
    year = params[:date][:year].to_i
    month = params[:date][:month].to_i
    company = Company.find(params[:id].to_i)
    begin
      params[:payments_for].each_pair do |employee, amount|
        amount = amount.to_i
        payment = Payment.where(year: year, month: month, company: company, employee_id: employee.to_i).first
        existed = !!payment
        payment||= Payment.new(year: year, month: month, company: company, employee_id: employee.to_i)
        if existed and amount == 0
          payment.destroy!
        else
          payment.amount = amount
          payment.save! unless amount == 0
        end
      end
      redirect_to edit_payments_company_path(date: { year: year, month: month }), notice: t('payment.successfully_updated')
    rescue Exception => e
      redirect_to edit_payments_company_path(date: { year: year, month: month }), alert: e.message
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      ps = params.require(:company).permit(:vat, :name, :district, :property_type, :property_type_id)
      ps[:name] && ps[:name].squish!
      ps[:district] && ps[:district].squish!
      ps
    end
end

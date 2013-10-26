class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :new]

  def index
    @contracts = Contract.all
  end

  def new
    filter_data
    # this controller also renders employee and company _form pages, so
    # variables have to be set:
    @employee = Employee.new
    @company = Company.new
    self.redirect=(url_for(
        company_id: @contract.company_id,
        employee_id:@contract.employee_id,
        filtered: @filtered))
  end

  def create
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save(contract_params)
        format.html { redirect_to @contract, notice: t('contract.successfully_created') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    filter_data
  end

  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to @contract, notice: t('contract.successfully_updated')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract.destroy
    redirect_to contracts_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contract
    @contract = params[:id].nil? ? Contract.new(contract_params) : Contract.find(params[:id])
  end

  def contract_params
    if params[:company_id]
      params[:contract]||={}
      params[:contract][:company_id]=params[:company_id]
    end
    if params[:employee_id]
      params[:contract]||={}
      params[:contract][:employee_id]=params[:employee_id] if params[:employee_id]
    end
    params.require(:contract).permit! if params[:contract]
  end

  def filter_data
    if filtered?('company')
      @employees = employees_not_from_company @contract.company
    else
      @employees = Employee.all
    end

    if filtered?('employee')
      @companies = companies_without_employee @contract.employee
    else
      @companies = Company.all
    end
  end

  def companies_without_employee employee
    employee.nil? ? Company.all : Company.all-employee.companies
  end

  def employees_not_from_company company
    company.nil? ? Employee.all : Employee.all-company.employees
  end

end

class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy, :new]

  # GET /transfers
  # GET /transfers.json
  def index
    conditions = {}
    conditions.merge! company_id: params[:company_id] if filtered? :company
    conditions.merge! year: params[:year] if filtered? :date
    conditions.merge! month: params[:month] if filtered? :date
    @transfers = Transfer.where(conditions)
    @companies = Company.all
    @current_params = {year: params[:year],
                       month: params[:month],
                       company_id: params[:company_id]}
    self.redirect_link = url_for(@current_params.merge('filtered[company]' => filtered?(:company),
                                                       'filtered[date]' => filtered?(:date)))
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
    flash.keep
  end

  # GET /transfers/new
  def new
    flash.keep
  end

  # GET /transfers/1/edit
  def edit
    flash.keep
  end

  # POST /transfers
  # POST /transfers.json
  def create
    @transfer = Transfer.new(transfer_params)

    respond_to do |format|
      if @transfer.save
        format.html { redirect_to redirect_link || @transfer, notice: t('transfer.successfully_created') }
        format.json { render action: 'show', status: :created, location: @transfer }
      else
        flash.keep
        format.html { render action: 'new' }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfers/1
  # PATCH/PUT /transfers/1.json
  def update
    respond_to do |format|
      if @transfer.update(transfer_params)
        format.html { redirect_to redirect_link || @transfer, notice: t('transfer.successfully_updated') }
        format.json { head :no_content }
      else
        flash.keep
        format.html { render action: 'edit' }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.json
  def destroy
    @transfer.destroy
    respond_to do |format|
      format.html { redirect_to redirect_link || transfers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = params[:id].nil? ? Transfer.new(transfer_params) : Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.require(:transfer).permit! if params[:transfer]
    end
end

class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

  # GET /transfers
  # GET /transfers.json
  def index
    conditions = {}
    conditions.merge! company_id: params[:company_id] if filtered? :company
    conditions.merge! year: params[:year] if filtered? :date
    conditions.merge! month: params[:month] if filtered? :date
        #year: params[:year] if filtered? :date,
        #                                 month: params[:month]
    @transfers = Transfer.where(conditions)
    @companies = Company.all
    self.redirect_link = url_for(year: params[:year],
                         month: params[:month],
                         company_id: params[:company_id],
                         'filtered[company]' => params[:filtered] && params[:filtered].include?('company'),
                         'filtered[date]' => params[:filtered] && params[:filtered].include?('date'))
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
    flash.keep
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
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
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.require(:transfer).permit(:company_id, :transfer_date, :amount, :month, :year)
    end
end

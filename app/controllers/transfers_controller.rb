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

  def bulk_edit
    month = DateTime.now.month
    year = DateTime.now.year
    params[:date]||= { year: year, month: month }
    @transfers = Transfer.where(month: params[:date][:month], year: params[:date][:year])
    actual_transfers_company_ids = @transfers.map do |t| t.company.id end
    new_transfers = Company.all.map do |c|
      Transfer.new(company: c,
                   month: month,
                   year: year,
                   amount: 0,
                   transfer_date: DateTime.now
      ) unless actual_transfers_company_ids.include? c.id
    end.compact
    @transfers = @transfers + new_transfers
    @current_params = {year: params[:date][:year],
                       month: params[:date][:month]}
  end

  def bulk_save
    year = params[:date][:year].to_i
    month = params[:date][:month].to_i
    date_hash = to_date_hash params[:transfer_dates]
    begin
      params[:amounts].each_pair do |company, amount|
        company = Company.find(company)
        amount = amount.to_i
        transfer = Transfer.where(
            year: year,
            month: month,
            company: company,
            transfer_date: date_hash[company.id]
        ).first
        existed = !!transfer
        transfer||= Transfer.new(
            year: year,
            month: month,
            company: company,
            transfer_date: date_hash[company.id]
        )
        if existed and amount == 0
          transfer.destroy!
        else
          transfer.amount = amount
          transfer.save! unless amount == 0
        end
      end
      redirect_to edit_transfers_path(date: { year: year, month: month }), notice: t('transfer.successfully_updated')
    rescue Exception => e
      redirect_to edit_transfers_path(date: { year: year, month: month }), alert: e.message
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

  #______PRIVATE_______#
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transfer
    @transfer = params[:id].nil? ? Transfer.new(transfer_params) : Transfer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transfer_params
    params.require(:transfer).permit! if params[:transfer]
  end

  def to_date_hash hash
    date_parts = {}
    hash.each_pair do |key, value|
      id, date_part = key.split /(?=\()/
      date_parts[id]||={}
      date_parts[id][date_part]=value
    end
    date_hash = {}
    date_parts.each_pair do |id, parts|
      date_hash[id.to_i]=Date.parse(parts.to_a.sort.collect{|c| c[1]}.join("-") )
    end
    date_hash
  end
end

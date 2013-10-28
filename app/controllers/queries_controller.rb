class QueriesController < ApplicationController
  def inspector
    @companies = Company.all
    inspector_query_params
    @result = Queries::inspector_query(*inspector_query_params) if inspector_query_params
  end

  def manager
    @result = Queries::manager_query(params[:year]).to_a if params[:year]
  end

  private
  def inspector_query_params
    query_params = [params[:company_id],
                        params[:average],
                        params[:from_year],
                        params[:from_month],
                        params[:to_year],
                        params[:to_month]]
    query_params.compact.length == 6 ? query_params.compact : false
  end

end

module ApplicationHelper
  def filtered? property
    @filtered||=[]
    #from_params = params[:filtered]
    #@filtered = @filtered + from_params
    @filtered.include? property
  end
end

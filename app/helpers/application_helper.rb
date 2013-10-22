module ApplicationHelper
  def filtered? property
    @filtered||=[]
    @filtered.include? property
  end
end

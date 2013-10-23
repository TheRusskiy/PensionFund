module ApplicationHelper
  def filtered? property
    @filtered||=[]
    @filtered.include? property
  end

  def if_permitted(controller, action, &block)
    if current_permission.permit? controller, action
      raw(block.call)
    else
      ''
    end
  end

  def permitted?( controller, action)
    current_permission.permit? controller, action
  end
end

module ApplicationHelper
  def filtered? property
    @filtered||=[]
    @filtered.include? property
  end

  def if_permitted(controller_resource, action_or_parameter, &block)
    if current_permission.permit? controller_resource, action_or_parameter \
    or current_permission.permit_parameters? controller_resource, action_or_parameter
      raw(block.call)
    else
      raw("<div class='hidden'>#{block.call}</div>")
    end
  end

  def permitted?( controller_resource, action_or_parameter)
    current_permission.permit? controller_resource, action_or_parameter \
    or current_permission.permit_parameters? controller_resource, action_or_parameter
  end
end

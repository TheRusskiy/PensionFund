module ApplicationHelper
  def filtered? property
    @filtered||=[]
    @filtered.include? property.to_s
  end

  def if_permitted(controller, action, &block)
    if current_permission.permit? controller, action
      raw(block.call)
    else
      raw("<div class='hidden'>#{block.call}</div>")
    end
  end

  def if_param_permitted(resource, parameter, &block)
    if current_permission.permit_parameters? resource, parameter
      raw(block.call)
    else
      raw("<div class='hidden'>#{block.call}</div>")
    end
  end

  def permitted?( controller, action)
    current_permission.permit? controller, action
  end

  def permitted_param?( resource, parameter)
    current_permission.permit? resource, parameter \
    or current_permission.permit_parameters? resource, parameter
  end

  def redirect_link extra_params = {}
    return nil if params[:redirect].blank?
    return params[:redirect] if extra_params.empty?

    # add/replace params in redirect link:
    url = URI(params[:redirect])
    redirect_query = Rack::Utils.parse_query url.query
    url.query = redirect_query.merge(extra_params).to_query
    url.to_s
  end

  def redirect_link=link
    params[:redirect]=link
  end
end

module ApplicationHelper
  def filtered? property
    @filtered||=[]
    if @filtered.respond_to? :keys
      f = @filtered[property.to_s]
      (f == 'true')||(f == true)
    else
      @filtered.include? property.to_s
    end
  end

  def if_permitted(controller, action, &block)
    return current_permission.permit? controller, action if block.nil?
    # if block was passed wrap it's content
    if current_permission.permit? controller, action
      raw(block.call)
    else
      raw("<div class='hidden'>#{block.call}</div>")
    end
  end

  def if_param_permitted(resource, parameter, &block)
    return current_permission.permit_parameters? resource, parameter if block.nil?
    # if block was passed wrap it's content
    if current_permission.permit_parameters? resource, parameter
      raw(block.call)
    else
      raw("<div class='hidden'>#{block.call}</div>")
    end
  end

  alias_method :permitted?, :if_permitted
  alias_method :param_permitted?, :if_param_permitted

  def redirect_link extra_params = {}
    link = flash[:redirect] unless flash[:redirect].blank?
    link = params[:redirect] unless params[:redirect].blank?
    return nil if link.blank?
    return link if extra_params.empty?

    # add/replace params in redirect link:
    url = URI(flash[:redirect])
    redirect_query = Rack::Utils.parse_query url.query
    url.query = redirect_query.merge(extra_params).to_query
    url.to_s
  end

  def redirect_link=link
    flash[:redirect]=link
  end
end

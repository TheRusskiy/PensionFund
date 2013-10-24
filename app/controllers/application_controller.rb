class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_filter :authorize
  before_filter :filter_forbidden_params

  helper_method :current_user
  helper_method :current_permission

  def authenticate
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to root_path, notice: I18n.t('menu.signed_in')
    else
      redirect_to root_path, alert: I18n.t('menu.wrong_credentials')
    end
  end

  def logout
    @current_user = nil
    session[:current_user_id] = nil
    redirect_to root_path, notice: I18n.t('menu.signed_out')
  end

  # PRIVATE METHODS:
  private

  def filter_forbidden_params
    params.each_pair do |resource, parameters|
      params[resource] = nil unless current_permission.permit_parameters? resource, parameters
      if parameters.respond_to? :each_key
        filtered_params = parameters.clone
        parameters.each_key do |p|
          filtered_params.delete(p) unless current_permission.permit_parameters? resource, p
        end
        params[resource]=filtered_params
      end
    end
  end

  def current_user
    id = params[:current_user_id] || session[:current_user_id]
    @current_user||= id ? User.find(id) : nil rescue nil
  end

  def current_permission
    @current_permission||= Permission.new(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    unless current_permission.permit?(params[:controller], params[:action], current_resource)
      redirect_to root_url, alert: I18n.t('not_authorized')
    end
  end

  def set_locale
    locale = params[:locale] || session[:locale] || :en
    session[:locale] = locale
    I18n.locale=locale
  end

  def redirect_link extra_params = {}
    return false if params[:redirect].blank?
    url = URI(params[:redirect])
    redirect_query = Rack::Utils.parse_query url.query
    # add/replace params in redirect link:
    url.query = redirect_query.merge(extra_params).to_query
    url.to_s
  end
end

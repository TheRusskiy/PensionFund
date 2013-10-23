class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize
  before_action :set_locale


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

  def logout
    @current_user = nil
    session[:current_user_id] = nil
    redirect_to root_path, notice: I18n.t('menu.signed_out')
  end
end

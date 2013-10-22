class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    id = params[:current_user_id] || session[:current_user_id]
    @current_user||= id ? User.find(id) : nil
  end

  helper_method :current_user

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
end

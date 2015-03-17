class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def set_locale
    if params[:locale]
      I18n.locale = cookies[:locale] = params[:locale]
    elsif cookies[:locale]
      I18n.locale = cookies[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:nickname, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nickname, :location, :email, :password, :current_password) }
  end
end

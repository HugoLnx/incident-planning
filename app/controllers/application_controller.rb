class ApplicationController < AuthorizationFrontController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_roles, if: :devise_controller?

protected

  def set_roles
    @roles = Roles::Dao.new.all
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, roles_ids: [])
    end

    devise_parameter_sanitizer.for :account_update do |u|
      u.permit(:email, :password, :password_confirmation, :current_password, roles_ids: [])
    end
  end
end

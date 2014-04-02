module DevisePatchController
  extend ActiveSupport::Concern

  included do
    before_filter :configure_permitted_parameters, if: :devise_controller?
    before_filter :set_roles, if: :devise_controller?

    def after_sign_out_path_for(resource_or_scope)
      session_path resource_or_scope
    end

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
end

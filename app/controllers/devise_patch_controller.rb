module DevisePatchController
  extend ActiveSupport::Concern

  COMMON_ATTRS = %i{email name phone password password_confirmation}

  included do
    before_filter :configure_permitted_parameters, if: :devise_controller?
    before_filter :set_roles, if: :devise_controller?

  protected

    def after_sign_out_path_for(resource_or_scope)
      session_path resource_or_scope
    end

    def set_roles
      @roles = Roles::Dao.new.all
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(*COMMON_ATTRS, roles_ids: [])
      end

      devise_parameter_sanitizer.for :account_update do |u|
        u.permit(*COMMON_ATTRS + %i{current_password}, roles_ids: [])
      end
    end
  end
end

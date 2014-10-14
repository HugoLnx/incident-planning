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
        u = u.permit(*COMMON_ATTRS + %i{company_id company_name}, roles_ids: [])
        if !Company.exists?(u[:company_id])
          c = Company.find_or_create_by(name: u[:company_name])
          u[:company_id] = c.id
        end
        u.delete(:company_name)
        u
      end

      devise_parameter_sanitizer.for :account_update do |u|
        u.permit(*COMMON_ATTRS + %i{current_password}, roles_ids: [])
      end
    end
  end
end

class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]

protected
  def after_update_path_for(resource_or_scope)
    from_config_back_path
  end

  def sign_up(resource_name, resource)
  end
end

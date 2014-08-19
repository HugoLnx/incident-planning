class RegistrationsController < Devise::RegistrationsController
protected
  def after_update_path_for(resource_or_scope)
    from_config_back_path
  end
end

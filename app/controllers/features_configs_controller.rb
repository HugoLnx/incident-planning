class FeaturesConfigsController < ApplicationController
  def edit
    @features_config = current_user.features_config
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user)
    set_filter_options
  end

  def update
    @features_config = current_user.features_config
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user, reuse_configuration_params)

    respond_to do |format|
      if @reuse_configuration.save && @features_config.update_attributes(config_params)
        format.html { redirect_to from_config_back_path, notice: 'Features configuration was successfully updated.' }
      else
        set_filter_options
        format.html { render action: 'edit' }
      end
    end
  end

private
  def config_params
    params.require(:features_config).permit(:thesis_tools)
  end

  def reuse_configuration_params
    params.require(:reuse_configuration).permit(:user_filter, :incident_filter, :reuse_hierarchy, :date_filter, :enabled)
  end

  def set_filter_options
    @user_filter_options = @reuse_configuration.user_filter_options
    @incident_filter_options = @reuse_configuration.incident_filter_options
  end
end

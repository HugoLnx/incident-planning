class ReuseConfigurationsController < ApplicationController
  def edit
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user)
    set_filter_options
  end

  def update
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user, reuse_configuration_params)

    respond_to do |format|
      if @reuse_configuration.save
        format.html { redirect_to from_config_back_path, notice: 'Reuse configuration was successfully updated.' }
      else
        set_filter_options
        format.html { render action: 'edit' }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reuse_configuration_params
      params.require(:reuse_configuration).permit(:user_filter, :incident_filter, :reuse_hierarchy, :date_filter, :enabled)
    end

    def set_filter_options
      @user_filter_options = @reuse_configuration.user_filter_options
      @incident_filter_options = @reuse_configuration.incident_filter_options
    end
end

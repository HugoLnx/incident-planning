class FeaturesConfigsController < ApplicationController
  def edit
    @features_config = current_user.features_config
  end

  def update
    @features_config = current_user.features_config

    respond_to do |format|
      if @features_config.update_attributes(config_params)
        format.html { redirect_to from_config_back_path, notice: 'Features configuration was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

private
  def config_params
    params.require(:features_config).permit(:authority_control, :traceability)
  end
end

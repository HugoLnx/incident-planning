class ReuseConfigurationsController < ApplicationController
  def edit
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user)
  end

  def update
    @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user, reuse_configuration_params)

    respond_to do |format|
      if @reuse_configuration.save
        format.html { redirect_to back_path, notice: 'Reuse configuration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reuse_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reuse_configuration_params
      params.require(:reuse_configuration).permit(:user_filter, :incident_filter, :reuse_hierarchy)
    end
end

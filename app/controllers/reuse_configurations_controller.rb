class ReuseConfigurationsController < ApplicationController
  before_action :set_reuse_configuration, only: [:edit, :update]

  def edit
  end

  def update
    respond_to do |format|
      if @reuse_configuration.update(reuse_configuration_params)
        format.html { redirect_to back_path, notice: 'Reuse configuration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reuse_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reuse_configuration
      @reuse_configuration = Forms::ReuseConfigurationForm.new(current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reuse_configuration_params
      params.require(:reuse_configuration).permit(:user_filter, :incident_filter, :reuse_hierarchy)
    end
end

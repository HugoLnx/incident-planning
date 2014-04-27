class CycleConfirmationsController < ApplicationController
  before_filter :set_incident

  def show
    @form202 = Forms::Form202.new(cycle_params)
  end

private
  def set_incident
    @incident = Incident.find(params[:incident_id])
  end

  def cycle_params
    cycle_params = params.require(:cycle).permit(:number, :from, :to, :objectives_text, :priorities)
    Forms::Form202.normalize(cycle_params)
  end
end

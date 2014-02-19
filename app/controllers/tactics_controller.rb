class TacticsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    tactic_params = params[:tactic].permit(:who, :what, :where, :when, :response_action, :father_id)

    p tactic_params

    head :ok
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

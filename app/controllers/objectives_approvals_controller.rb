class ObjectivesApprovalsController < ApplicationController
  before_action :set_cycle
  before_action :set_incident

  def create
    respond_to do |format|
      if @cycle.approve_all_objectives(current_user)
        format.html {redirect_to incident_cycle_path(@incident, @cycle), notice: "Objectives were sucessfuly approved."}
      else
        format.html {render status: :not_implemented, text: "Error, approvals were not saved and this case was not treated yet"}
      end
    end
  end

private
  def set_cycle
    @cycle = Cycle.find(params[:cycle_id])
  end

  def set_incident
    @incident = Incident.find(params[:incident_id])
  end
end

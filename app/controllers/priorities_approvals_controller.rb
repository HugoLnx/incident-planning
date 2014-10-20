class PrioritiesApprovalsController < ApplicationController
  before_action :set_cycle
  before_action :set_incident

  def create
    @cycle.priorities_approval_status = true

    respond_to do |format|
      if @cycle.save
        format.html {redirect_to incident_cycle_analysis_matrix_path(@incident, @cycle), notice: "Command Emphasis was sucessfuly approved."}
      else
        format.html {render status: :not_implemented, text: "Error, approval wasn't saved and this case was not treated yet"}
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

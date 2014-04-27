class ObjectivesApprovalsController < ApplicationController
  before_action :set_cycle
  before_action :set_incident

  def create
    objectives = @cycle.text_expressions.objectives.includes(:approvals)
    approvals = ApprovalCollection.new
    objectives.each do |objective|
      new_approvals = Approval.build_all_to(current_user, positive: true, approve: objective)
      approvals += new_approvals
    end

    respond_to do |format|
      if approvals.save
        format.html {redirect_to incident_cycle_analysis_matrix_path(@incident, @cycle), notice: "Objectives were sucessfuly approved."}
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

class TacticsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    tactic_params = params[:tactic].permit(:who, :what, :where, :when, :response_action, :father_id)

    tactic_params[:cycle_id] = @cycle.id

    tactic = HighModels::Tactic.new(tactic_params)
    tactic.save

    head :ok
  end

  def update
    new_params = params[:tactic].permit(:who, :what, :where, :when, :response_action)

    group = Group.includes(:text_expressions).find(params[:id])

    tactic = HighModels::Tactic.new
    tactic.set_from_group group
    tactic.update new_params
    tactic.save

    head :ok
  end

  def destroy
    group = Group.includes(:text_expressions).find(params[:id])

    tactic = HighModels::Tactic.new
    tactic.set_from_group group
    tactic.destroy

    head :ok
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

class TacticsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    tactic_params = params[:tactic].permit(:who, :what, :where, :when, :response_action,
      :who_reused, :what_reused, :where_reused, :when_reused, :response_action_reused, :father_id)
    tactic_params[:owner] = current_user

    tactic_params[:cycle_id] = @cycle.id
    
    AnalysisMatrixReuse::ParamsCleaner.clean(tactic_params)

    tactic = HighModels::Tactic.new(tactic_params)
    tactic.save

    head :ok
  end

  def update
    new_params = params[:tactic].permit(:who, :what, :where, :when, :response_action)

    group = Group.includes(:text_expressions, :time_expressions).find(params[:id])

    tactic = HighModels::Tactic.new owner: current_user
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

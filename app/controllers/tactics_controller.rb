class TacticsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    tactic_params = get_tactic_params(extra_permitted: [:father_id])

    tactic_params[:owner] = current_user
    tactic_params[:cycle_id] = @cycle.id
    
    AnalysisMatrixReuse::ParamsCleaner.clean(tactic_params)

    tactic = HighModels::Tactic.new(tactic_params)
    tactic.save

    head :ok
  end

  def update
    new_params = get_tactic_params

    AnalysisMatrixReuse::ParamsCleaner.clean(new_params)

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

  def get_tactic_params(extra_permitted: [])
    permitted = %i{who what where when response_action
      who_reused what_reused where_reused when_reused response_action_reused}
    permitted += extra_permitted
    tactic_params = params[:tactic].permit(*permitted)

    %i{who_reused what_reused where_reused response_action_reused}.each do |param|
      tactic_params[param] = TextExpression.find_by_id(tactic_params[param])
    end

    tactic_params[:when_reused] = TimeExpression.find_by_id(tactic_params[:when_reused])
    tactic_params
  end
end

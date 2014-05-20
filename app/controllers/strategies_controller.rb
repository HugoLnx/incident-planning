class StrategiesController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    strategy_params = params[:strategy].permit(:how, :father_id, :how_reused)

    strategy_params[:owner] = current_user

    strategy_params[:cycle_id] = @cycle.id

    AnalysisMatrixReuse::ParamsCleaner.clean(strategy_params)

    strategy = HighModels::Strategy.new(strategy_params)
    strategy.save!

    configuration = current_user.reuse_configuration

    if configuration.reuse_hierarchy? && strategy_params[:how_reused]
      AnalysisMatrixReuse::Strategy.reuse_tactics!(strategy.group, current_user)
    end

    head :ok
  end

  def update
    new_params = params[:strategy].permit(:how, :how_reused)

    AnalysisMatrixReuse::ParamsCleaner.clean(new_params)

    group = Group.includes(:text_expressions).find(params[:id])

    strategy = HighModels::Strategy.new owner: current_user
    strategy.set_from_group group
    strategy.update new_params
    strategy.save!

    head :ok
  end

  def destroy
    group = Group.includes(:text_expressions).find(params[:id])

    strategy = HighModels::Strategy.new
    strategy.set_from_group group
    strategy.destroy

    head :ok
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

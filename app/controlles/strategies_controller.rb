class StrategiesController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    strategy_params = params[:strategy].permit(:how, :why, :father_id)

    strategy_params[:cycle_id] = @cycle.id

    strategy = HighModels::Strategy.new(strategy_params)
    strategy.save

    head :ok
  end

  def update
    new_params = params[:strategy].permit(:how, :why)

    group_id = params[:group_id]

    strategy = HighModels::Strategy.load(group_id)
    strategy.update new_params
    strategy.save

    head :ok
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

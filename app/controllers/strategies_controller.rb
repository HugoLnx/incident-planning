class StrategiesController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    strategy_params = params[:strategy].permit(:how, :father_id, :how_reused)
    strategy_params[:how_reused] = TextExpression.find_by_id(strategy_params[:how_reused])

    strategy_params[:owner] = current_user

    strategy_params[:cycle_id] = @cycle.id

    AnalysisMatrixReuse::ParamsCleaner.clean(strategy_params)

    strategy = HighModels::Strategy.new(strategy_params)
    strategy.save!

    if is_reusing_hierarchy?(strategy_params)
      reused_strategy = Group.father_of_expression(strategy_params[:how_reused]).first
      AnalysisMatrixReuse::Strategy.reuse_tactics!(strategy.group,
        reused: reused_strategy, owner: current_user)
    end

    @strategy = strategy.group

    render text: "success"
  end

  def update
    new_params = params[:strategy].permit(:how, :how_reused)
    new_params[:how_reused] = TextExpression.find_by_id(new_params[:how_reused])

    AnalysisMatrixReuse::ParamsCleaner.clean(new_params)

    group = Group.includes(:text_expressions).find(params[:id])
    strategy_old_childs = group.childs.load

    strategy = HighModels::Strategy.new owner: current_user
    strategy.set_from_group group
    strategy.update new_params
    strategy.save!


    if is_reusing_hierarchy?(new_params)
      ids = strategy_old_childs.map(&:id)
      Group.destroy(ids)

      reused_strategy = Group.father_of_expression(new_params[:how_reused]).first
      AnalysisMatrixReuse::Strategy.reuse_tactics!(strategy.group,
        reused: reused_strategy, owner: current_user)
    end

    @strategy = strategy.group
    @strategy.reload

    render text: "success"
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

  def is_reusing_hierarchy?(strategy_params)
    reused_id = strategy_params[:how_reused]
    configuration = current_user.reuse_configuration
    is_reusing = configuration.reuse_hierarchy? && reused_id

    reused_have_hierarchy = !Group.childs_of_father_of_text_expression(reused_id).empty?
    return is_reusing && reused_have_hierarchy
  end
end

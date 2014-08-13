class PublishesController < ApplicationController
  before_filter :set_incident_and_cycle

  def publish
    prepare_to_render_analysis_matrix

    all_messages = Publish::PublishValidation.errors_messages_on(@objectives)
    @expression_errors = all_messages[:expression]
    @group_errors = all_messages[:group]

    if @expression_errors.empty? && @group_errors.empty?
      Publish::Publisher.publish(@cycle)
      redirect_to action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix

    all_errors = Publish::PublishValidation.errors_messages_on(@objectives)
    @expression_errors = all_errors[:expression]
    @group_errors = all_errors[:group]

    render "analysis_matrices/show"
  end

  def show
    prepare_to_render_analysis_matrix
  end

private

  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end

  def prepare_to_render_analysis_matrix
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    @objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(@objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic
  end
end

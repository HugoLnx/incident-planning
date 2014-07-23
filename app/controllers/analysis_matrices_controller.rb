class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    prepare_to_render_analysis_matrix
  end

  def group_approval
    prepare_to_render_analysis_matrix

    render "show_group_approval"
  end

  def group_deletion
    prepare_to_render_analysis_matrix

    render "show_group_deletion"
  end

  def publish_validation
    prepare_to_render_analysis_matrix

    all_errors = Publish::PublishValidation.errors_on(@objectives)
    @expression_errors = Publish::PublishValidation.get_messages(all_errors[:expression])
    @group_errors = Publish::PublishValidation.get_messages(all_errors[:group])

    render "show"
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

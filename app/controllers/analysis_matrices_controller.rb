class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    if @cycle.closed?
      redirect_to incident_cycle_publishes_path(@incident, @cycle)
    else
      prepare_to_render_analysis_matrix
    end
  end

  def group_approval
    prepare_to_render_analysis_matrix

    render "show_group_approval"
  end

  def group_deletion
    prepare_to_render_analysis_matrix

    render "show_group_deletion"
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

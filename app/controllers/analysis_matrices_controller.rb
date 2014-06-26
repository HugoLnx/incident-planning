class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic
  end

  def group_approval
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic

    @submit_path = group_approval_path

    render "show_groups_selection"
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

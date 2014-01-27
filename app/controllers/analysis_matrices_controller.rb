class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

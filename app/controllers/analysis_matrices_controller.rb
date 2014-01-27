class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    @matrix_data = AnalysisMatrixData.new(dao)
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

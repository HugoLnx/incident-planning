class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)
  end

  def create
    strategy_params = params[:strategy].permit(:how, :why, :father_id)

    p strategy_params

    render text: "success"
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

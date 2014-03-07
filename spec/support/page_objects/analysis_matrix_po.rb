module PageObjects
  class AnalysisMatrixPO
    def initialize(session, routing_helpers)
      @session = session
      @routing = routing_helpers
    end

    def path(cycle)
      @routing.incident_cycle_analysis_matrix_path(cycle.incident, cycle)
    end

    def visit(cycle)
      @session.visit path(cycle)
    end
    
    def row_of_objective(index)
      obj_tds =  @session.all("#analysis-matrix .objective.non-repeated")
      obj_td = obj_tds[index]
      obj_row = obj_td.find(:xpath, "..")
      AnalysisMatrixRowPO.new(obj_row)
    end
  end
end

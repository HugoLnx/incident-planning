module PageObjects
  class AnalysisMatrixPO
    def initialize(user_knowledge)
      @user = user_knowledge
      @session = user_knowledge.session
      @routing = user_knowledge.routing
    end

    def path(cycle)
      @routing.incident_cycle_analysis_matrix_path(cycle.incident, cycle)
    end

    def visit(cycle)
      @session.visit path(cycle)
    end
    
    def row_of_objective(index)
      objs_elements = all_non_repeated_objective_elements
      obj_element = objs_elements[index]
      row_element = find_row_of(obj_element)
      AnalysisMatrixRowPO.new(@user, row_element)
    end

    def cell_of_strategy(index, from_objective: nil)
      obj_index = from_objective
      objs_elements = all_non_repeated_objective_elements
      obj_element = objs_elements[obj_index]
      row_element = obj_element.find(:xpath, "..")
      if index == 0
        element = row_element.find(".strategy.non-repeated")
      else
        rows_elements = obj_element.all(:xpath, "../following-sibling::*").to_a
        rows_elements.keep_if{|element| element.has_css?(".strategy.non-repeated")}
        element = rows_elements[index-1]
      end

      AnalysisMatrixCellPO.new(@user, element)
    end
  private
    def all_non_repeated_objective_elements
      @session.all("#analysis-matrix .objective.non-repeated")
    end

    def find_row_of(element)
      element.find(:xpath, "..")
    end
  end
end

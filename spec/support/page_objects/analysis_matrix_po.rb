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

    def print_draft
      @session.click_button "Print Draft"
    end
    
    def row_of_objective(index)
      objs_elements = all_non_repeated_objective_elements
      obj_element = objs_elements[index]
      row_element = find_row_of(obj_element)
      AnalysisMatrixRowPO.new(@user, row_element)
    end

    def row_of_tactic(index, from_strategy: nil, from_objective: nil)
      cell = cell_of_tactic_expression(:who,
        from_tactic: index,
        from_strategy: from_strategy,
        from_objective: from_objective
      )
      row_element = cell.element.find(:xpath, '..')
      AnalysisMatrixRowPO.new(@user, row_element)
    end

    def cell_of_objective(index)
      objs_elements = all_non_repeated_objective_elements
      AnalysisMatrixCellPO.new(@user, objs_elements[index])
    end

    def cell_of_strategy(index, from_objective: nil)
      obj_index = from_objective
      obj_element = cell_of_objective(obj_index).element
      row_element = obj_element.find(:xpath, "..")
      if index == 0
        element = row_element.find(".strategy.non-repeated")
      else
        rows_elements = obj_element.all(:xpath, "../following-sibling::*").to_a
        rows_elements.keep_if{|element| element.has_css?(".strategy.non-repeated")}
        element = rows_elements[index-1]
      end

      AnalysisMatrixStrategyCellPO.new(@user, element)
    end

    def cell_of_tactic_expression(expression_name, from_tactic: nil, from_strategy: nil, from_objective: nil)
      index = from_tactic
      obj_index = from_objective
      strat_index = from_strategy
      strat_element = cell_of_strategy(strat_index, from_objective: obj_index).element
      row_element = strat_element.find(:xpath, "..")
      if index == 0
        element = row_element.find(".tactic.#{expression_name}.non-repeated")
      else
        rows_elements = strat_element.all(:xpath, "../following-sibling::*").to_a
        rows_elements.keep_if{|element| element.has_css?(".tactic.#{expression_name}.non-repeated")}
        element = rows_elements[index-1]
      end

      AnalysisMatrixTacticCellPO.new(@user, element)
    end

    def notice
      @session.find(".notice")
    end

    def disable_show_metadata
      @session.execute_script("$('.analysis-matrix').off('click');");
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

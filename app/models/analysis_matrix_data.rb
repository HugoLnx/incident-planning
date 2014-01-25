class AnalysisMatrixData
  def initialize(dao)
    @tactics = dao.find_all_tactics_including_hierarchy
  end

  def each_row(&block)
    current_objective = nil
    current_strategy = nil
    @tactics.each do |current_tactic|
      row = {}
      tactic_expression = current_tactic.text_expressions.find{|t| t.name == Model.tactic_where.name}
      tactic_expression && row[:tactic] = tactic_expression

      if current_tactic.father != current_strategy
        row[:strategy] = current_tactic.father.text_expressions.find{|s| s.name == Model.strategy_how.name}
      end
      current_strategy = current_tactic.father

      if current_strategy.father != current_objective
        row[:objective] = current_strategy.father.text_expressions.find{|o| o.name == Model.objective.name}
      end
      current_objective = current_strategy.father

      yield AnalysisMatrixData::Row.new(row[:objective], row[:strategy], row[:tactic])
    end
  end

  class Row
    attr_reader :tactic, :strategy, :objective

    def initialize(objective, strategy, tactic)
      @objective = objective
      @strategy = strategy
      @tactic = tactic
    end
  end
end

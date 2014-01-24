module AnalysisMatricesHelper
  class AnalysisMatrixData
    def initialize(cycle)
      @objectives = cycle.groups.where(name: Model.objective.name).includes(:text_expressions, :childs, :father)
      @strategies = @objectives.map{|objective| objective.childs.includes(:text_expressions, :childs, :father)}.flatten
      @tactics = @strategies.map{|strategy| strategy.childs.includes(:text_expressions, :childs, :father)}.flatten
    end

    def each_row(&block)
      objective = nil
      strategy = nil
      @tactics.each do |tactic|
        row = {}
        tactic_expression = tactic.text_expressions.where(name: Model.tactic_where.name).first
        tactic_expression && row[:tactic] = tactic_expression.text

        if tactic.father != strategy
          row[:strategy] = tactic.father.text_expressions.where(name: Model.strategy_how.name).first.text
        end
        strategy = tactic.father

        if strategy.father != objective
          row[:objective] = strategy.father.text_expressions.where(name: Model.objective.name).first.text
        end
        objective = strategy.father

        yield row
      end
    end
  end
end

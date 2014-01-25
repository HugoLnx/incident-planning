class AnalysisMatrixData
  def initialize(dao)
    @tactics = dao.find_all_tactics_including_hierarchy
  end

  def each_row(&block)
    current_objective = nil
    current_strategy = nil
    @tactics.each do |current_tactic|
      row = {}
      row[:tactic_repeated] = false
      row[:stragegy_repeated] = false
      row[:objective_repeated] = false

      if current_tactic.father == current_strategy
        row[:strategy_repeated] = true
      end
      current_strategy = current_tactic.father

      if current_strategy.father == current_objective
        row[:objective_repeated] = true
      end
      current_objective = current_strategy.father

      row[:tactic] = Groups::Tactic.new(current_tactic)
      row[:strategy] = Groups::Strategy.new(current_strategy)
      row[:objective] = Groups::Objective.new(current_objective)

      yield AnalysisMatrixData::Row.new(row)
    end
  end

  class Row
    attr_reader :tactic, :strategy, :objective
    attr_reader :tactic_repeated, :strategy_repeated, :objective_repeated

    def initialize(row = {})
      @objective = row[:objective]
      @strategy = row[:strategy]
      @tactic = row[:tactic]
      @objective_repeated = row[:objective_repeated]
      @strategy_repeated = row[:strategy_repeated]
      @tactic_repeated = row[:tactic_repeated]
    end
  end
end

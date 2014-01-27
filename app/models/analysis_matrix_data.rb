class AnalysisMatrixData
  def initialize(objectives)
    @objectives = objectives
    @strategies = @objectives.map(&:childs).flatten
    @tactics = @strategies.map(&:childs).flatten
    @last_row = {}
  end

  def rows
    rows = []
    self.each_row{|row| rows << row}
    return rows
  end

  def each_row(&block)
    stacks = [@objectives.reverse]
    while !stacks.empty? do
      last_stack = stacks.last
      if last_stack.last.childs.empty?
        to_yield = stacks.map(&:last)

        yield_with *to_yield, &block

        pop_consumed_groups(stacks)
      else
        stacks << last_stack.last.childs.reverse
      end
    end
  end

private

  def pop_consumed_groups(stacks)
    last_stack = stacks.last
    last_stack.pop
    while last_stack && last_stack.empty?
      stacks.pop 
      last_stack = stacks.last
      last_stack && last_stack.pop
    end
  end

  def yield_with(objective, strategy = nil, tactic = nil, &block)
    row = {}
    row[:tactic] = Groups::Tactic.new(tactic) if tactic
    row[:strategy] = Groups::Strategy.new(strategy) if strategy
    row[:objective] = Groups::Objective.new(objective)

    row[:tactic_repeated] = (row[:tactic] && row[:tactic] == @last_row[:tactic])
    row[:strategy_repeated] = (row[:strategy] && row[:strategy] == @last_row[:strategy])
    row[:objective_repeated] = (row[:objective] && row[:objective] == @last_row[:objective])

    @last_row = row

    yield AnalysisMatrixData::Row.new(row)
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

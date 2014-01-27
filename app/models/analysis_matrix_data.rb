class AnalysisMatrixData
  def initialize(objectives)
    @objectives = objectives
    @strategies = @objectives.map(&:childs).flatten
    @tactics = @strategies.map(&:childs).flatten
    @previous_row = nil
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

    row = AnalysisMatrixData::Row.new(row, @previous_row)
    @previous_row = row
    yield row
  end

  class Row
    attr_reader :tactic, :strategy, :objective

    def initialize(row = {}, previous_row=nil)
      @objective = row[:objective]
      @strategy = row[:strategy]
      @tactic = row[:tactic]
      @previous = previous_row
    end

    def has_objective_repeated?
      @previous && @objective && @objective == @previous.objective
    end

    def has_strategy_repeated?
      @previous && @strategy && @strategy == @previous.strategy
    end

    def has_tactic_repeated?
      @previous && @tactic && @tactic == @previous.tactic
    end
  end
end

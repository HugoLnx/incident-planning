class AnalysisMatrixData
  def initialize(objectives)
    @objectives = objectives
    @strategies = @objectives.map(&:childs).flatten
    @tactics = @strategies.map(&:childs).flatten
    @previous_row = nil
  end

  def rows
    rows = []
    stacks = [@objectives.reverse]
    while !stacks.empty? do
      last_stack = stacks.last
      if last_stack.last.childs.empty?
        to_row = stacks.map(&:last)

        rows << build_row(*to_row)

        pop_consumed_groups(stacks)
      else
        stacks << last_stack.last.childs.reverse
      end
    end

    rows = set_lasts_in_rows(rows)

    rows
  end

  def each_row(&block)
    rows.each(&block)
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

  def build_row(objective, strategy = nil, tactic = nil, &block)
    row = {}
    row[:tactic] = Groups::Tactic.new(tactic) if tactic
    row[:strategy] = Groups::Strategy.new(strategy) if strategy
    row[:objective] = Groups::Objective.new(objective)

    row = AnalysisMatrixData::Row.new(row, @previous_row)
    @previous_row = row
    row
  end

  def set_lasts_in_rows(rows)
    previous = nil
    last_objective = true
    last_strategy = true
    last_tactic = true

    rows.reverse_each do |row|
      if previous
        if previous.tactic != row.tactic
          last_tactic = false
        end

        if previous.strategy != row.strategy
          last_strategy = false
          last_tactic = true
        end

        if previous.objective != row.objective
          last_objective = false
          last_strategy = true
        end
      end

      row.objective_is_last_child = last_objective && row.objective
      row.strategy_is_last_child = last_strategy && row.strategy
      row.tactic_is_last_child = last_tactic && row.tactic

      previous = row
    end
  end

  class Row
    attr_reader :tactic, :strategy, :objective
    attr_writer :tactic_is_last_child, :strategy_is_last_child, :objective_is_last_child

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

    def has_objective_as_last_child?
      @objective_is_last_child
    end

    def has_strategy_as_last_child?
      @strategy_is_last_child
    end

    def has_tactic_as_last_child?
      @tactic_is_last_child
    end
  end
end

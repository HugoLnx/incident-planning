module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    first_row = true
    previous_row = nil

    matrix_data.each_row do |row|
      yield_extra_rows_with_forms(previous_row, row, &block)

      objective_cells = ObjectiveCells.from(self, row)
      strategy_cells = StrategyCells.from(self, row)
      tactic_cells = TacticCells.from(self, row)

      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)

      first_row = false
      previous_row = row
    end

    yield_extra_rows_with_forms(previous_row, &block)
  end

  def yield_extra_rows_with_forms(prev_row, row=nil, &block)
    return if prev_row.nil?

    if last_tactic_of_current_strategy?(row, prev_row)
      yield new_tactic_row(row, prev_row)
    end

    if last_strategy_of_current_objective?(row, prev_row)
      yield new_strategy_row(row, prev_row)
    end
  end

  def last_tactic_of_current_strategy?(row, prev_row)
    prev_row.tactic && (row.nil? || !row.has_strategy_repeated?)
  end

  def last_strategy_of_current_objective?(row, prev_row)
    prev_row.strategy && (row.nil? || !row.has_objective_repeated?)
  end

  def new_tactic_row(row, prev_row)
    tactic_cells = TacticCells::New.new(self)
    objective_cells = ObjectiveCells.from_previous(self, prev_row)
    strategy_cells = StrategyCells.from_previous(self, prev_row)
    AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
  end

  def new_strategy_row(row, prev_row)
    strategy_cells = StrategyCells::New.new(self)
    objective_cells = ObjectiveCells.from_previous(self, prev_row)
    tactic_cells = TacticCells.blank(self)
    AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
  end

  class ObjectiveCells
    PARTIAL = "objective_cells"

    def initialize(context, objective=nil, repeated=nil)
      @context = context
      @objective = objective
      @repeated = repeated
    end

    def self.from(context, row)
      ObjectiveCells.new(context, row.objective, row.has_objective_repeated?)
    end

    def self.from_previous(context, row)
      ObjectiveCells.new(context, row.objective, true)
    end

    def render
      text = @objective && @objective.expression && @objective.expression.text
      repeated_class = @repeated ? "repeated" : ""
      @context.render partial: PARTIAL, locals: {text: text, repeated: repeated_class}
    end
  end

  class StrategyCells
    def self.from(context, row)
      if row.strategy
        StrategyCells::Show.new(context, row.strategy, row.has_strategy_repeated?)
      else
        StrategyCells::New.new(context)
      end
    end

    def self.from_previous(context, row)
      StrategyCells::Show.new(context, row.strategy, true)
    end

    class Show
      PARTIAL = "strategy_cells"

      def initialize(context, strategy=nil, repeated=nil)
        @context = context
        @strategy = strategy
        @repeated = repeated
      end

      def render
        texts = {
          how: @strategy && @strategy.how && @strategy.how.text,
          why: @strategy && @strategy.why && @strategy.why.text
        }
        repeated_class = @repeated ? "repeated" : ""
        @context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_strategy_form_cells"

      def initialize(context)
        @context = context
      end

      def render
        @context.render partial: PARTIAL
      end
    end
  end

  class TacticCells
    def self.from(context, row)
      if row.strategy.nil?
        self.blank(context)
      elsif row.tactic
        TacticCells::Show.new(context, row.tactic, row.has_tactic_repeated?)
      else
        TacticCells::New.new(context)
      end
    end

    def self.blank(context)
      TacticCells::Show.new(context)
    end

    class Show
      PARTIAL = "tactic_cells"

      def initialize(context, tactic=nil, repeated=nil)
        @context = context
        @tactic = tactic
        @repeated = repeated
      end

      def render
        texts = {
          who:   @tactic && @tactic.who   && @tactic.who.text,
          what:  @tactic && @tactic.what  && @tactic.what.text,
          where: @tactic && @tactic.where && @tactic.where.text,
          when:  @tactic && @tactic.when  && @tactic.when.time,
          response_action: @tactic && @tactic.response_action && @tactic.response_action.text
        }
        repeated_class = @repeated ? "repeated" : ""
        @context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_tactic_form_cells"

      def initialize(context)
        @context = context
      end

      def render
        @context.render partial: PARTIAL
      end
    end
  end


  class Row
    attr_reader :objective_cells, :strategy_cells, :tactic_cells
    
    def initialize(objective_cells, strategy_cells, tactic_cells)
      @objective_cells = objective_cells
      @strategy_cells = strategy_cells
      @tactic_cells = tactic_cells
    end
  end
end

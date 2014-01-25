module AnalysisMatricesHelper
  class AnalysisMatrixCells
    def initialize(matrix_data)
      @matrix_data = matrix_data
    end

    def each_row(&block)
      first_row = true
      @matrix_data.each_row do |row|
        objective_text = row.objective && row.objective.text
        strategy_text = row.strategy && row.strategy.text
        tactic_text = row.tactic && row.tactic.text

        unless first_row
          if row.objective
            yield AnalysisMatrixData::Row.new(nil, :STRATEGY_FORM, nil)
          elsif row.strategy
            yield AnalysisMatrixData::Row.new(nil, nil, :TACTIC_FORM)
          end
        end

        yield AnalysisMatrixData::Row.new(objective_text, strategy_text, tactic_text)

        first_row = false
      end
    end
  end
end

module SuggestionsTree
  class DateSuggestion
    attr_accessor :exp_id, :date

    def self.from_expressions(expressions)
      expressions.group_by(&:created_at).map do |date, exps|
        exp = exps.first
        sug = DateSuggestion.new
        sug.exp_id = exp.id
        sug.date = date
        sug
      end
    end
  end
end

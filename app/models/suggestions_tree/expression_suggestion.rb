module SuggestionsTree
  class ExpressionSuggestion
    attr_accessor :exp_id, :text, :count, :incidents

    def self.from_expressions(expressions)
      expressions.group_by(&:info_as_str).map do |text, exps|
        exp = exps.first
        sug = ExpressionSuggestion.new
        sug.exp_id = exp.id
        sug.text = text
        sug.count = exps.size
        sug.incidents = IncidentSuggestion.from_expressions(exps)
        sug
      end
    end
  end
end

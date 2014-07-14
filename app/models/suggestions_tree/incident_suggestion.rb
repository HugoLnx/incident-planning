module SuggestionsTree
  class IncidentSuggestion
    attr_accessor :exp_id, :name, :count, :dates

    def self.from_expressions(expressions)
      expressions.group_by{|e| e.cycle.incident}.map do |incident, exps|
        exp = exps.first
        sug = IncidentSuggestion.new
        sug.exp_id = exp.id
        sug.name = incident.name
        sug.count = exps.size
        sug.dates = DateSuggestion.from_expressions(exps)
        sug
      end
    end
  end
end

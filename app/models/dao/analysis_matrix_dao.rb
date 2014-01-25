module Dao
  class AnalysisMatrixDao
    def initialize(cycle)
      @cycle = cycle
    end

    def find_all_tactics_including_hierarchy
      objectives = @cycle.groups.where(name: Model.objective.name).includes(
        :text_expressions,
        childs: [
          :text_expressions,
          {childs: [
            :childs,
            :text_expressions,
            {father: [:text_expressions, {father: :text_expressions}]}
          ]},
        ]
      )
      strategies = objectives.map(&:childs).flatten
      tactics = strategies.map(&:childs).flatten
      return tactics
    end
  end
end

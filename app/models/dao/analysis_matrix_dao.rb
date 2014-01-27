module Dao
  class AnalysisMatrixDao
    def initialize(cycle)
      @cycle = cycle
    end

    def find_all_objectives_including_hierarchy
      @cycle.groups.where(name: Model.objective.name).includes(
        :text_expressions,
        childs: [
          :text_expressions,
          {childs: [
            :childs,
            :text_expressions,
            {father: [:text_expressions, {father: :text_expressions}]}
          ]},
        ]
      ).load
    end
  end
end

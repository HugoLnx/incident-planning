module Dao
  class AnalysisMatrixDao
    def initialize(cycle)
      @cycle = cycle
    end

    def find_all_objectives_including_hierarchy
      expressions_includes =  [
        :owner,
        {
          approvals: [:user],
          reused_expression: [:owner, {approvals: [:user]}]
        }
      ]
      
      @cycle.groups.where(name: Model.objective.name).includes(
        text_expressions: expressions_includes,
        time_expressions: expressions_includes,
        childs: {
          text_expressions: expressions_includes,
          time_expressions: expressions_includes,
          childs: [
            :childs,
            {
              text_expressions: expressions_includes,
              time_expressions: expressions_includes,
              father: {
                text_expressions: expressions_includes,
                time_expressions: expressions_includes,
                father: {
                  text_expressions: expressions_includes,
                  time_expressions: expressions_includes
                }
              }
            }
          ]
        }
      ).load
    end
  end
end

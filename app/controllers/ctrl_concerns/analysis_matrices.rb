module CtrlConcerns
  module AnalysisMatrices
    extend ActiveSupport::Concern

    included do

    protected

      def prepare_to_render_analysis_matrix(cycle)
        dao = Dao::AnalysisMatrixDao.new(cycle)
        @objectives = dao.find_all_objectives_including_hierarchy
        @matrix_data = AnalysisMatrixData.new(@objectives)

        @objective = ::Model.objective
        @strategy = ::Model.strategy
        @tactic = ::Model.tactic
      end
    end
  end
end

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

        @publish_messages = Publish::PublishValidation.errors_messages_on(
          @objectives, disable_approvals: !current_user.features_config.thesis_tools?)

        @version_messages = Publish::VersionValidation.errors_messages_on(
          @objectives, disable_approvals: !current_user.features_config.thesis_tools?)

        @have_publish_errors = Publish::ValidationUtils.have_errors?(@publish_messages)
        @have_version_errors = Publish::ValidationUtils.have_errors?(@version_messages)

        @version_have_general_errors = !@cycle.approved?
        @publish_have_general_errors = !@cycle.next_to_be_published? || @cycle.changed_after_last_version? || @version_have_general_errors
        @priorities = PrioritiesProxy.new(@cycle)
      end

      def prepare_errors(all_messages)
        @expression_errors = all_messages[:expression]
        @group_errors = all_messages[:group]
      end

      def publish_errors?
        @have_publish_errors || @publish_have_general_errors
      end
      helper_method :publish_errors?

      def version_errors?
        @have_version_errors || @version_have_general_errors
      end
      helper_method :version_errors?
    end
  end
end

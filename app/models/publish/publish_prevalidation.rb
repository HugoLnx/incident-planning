module Publish
  class PublishPrevalidation
    MATRIX_ERRORS_MSG = "Check Matrix for Planning Item Alerts."

    def self.errors_messages_on(*args)
      all_errors = errors_on(*args)
      all_errors.map(&:last)
    end

    def self.errors_on(current_user, cycle, have_matrix_errors)
      errors = []
      
      errors += Prevalidation::Permission.errors_on(current_user).entries
      errors += Prevalidation::PreviousCyclesPublished.errors_on(cycle).entries
      errors += Prevalidation::NotChangedAfterLastVersion.errors_on(cycle).entries
      if have_matrix_errors
        errors.push([MATRIX_ERRORS_MSG])
      end

      errors
    end
  end
end

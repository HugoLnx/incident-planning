module Publish
  class VersionPrevalidation
    def self.errors_messages_on(*args)
      all_errors = errors_on(*args)
      all_errors.map(&:last)
    end

    def self.errors_on(cycle, have_matrix_errors)
      errors = []
      
      if !cycle.priorities_approved?
        errors.push(["Command Emphasis must be approved."])
      end

      if have_matrix_errors
        errors.push([Publish::PublishPrevalidation::MATRIX_ERRORS_MSG])
      end

      errors
    end
  end
end

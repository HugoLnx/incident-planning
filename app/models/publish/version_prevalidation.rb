module Publish
  class VersionPrevalidation
    def self.errors_messages_on(*args)
      all_errors = errors_on(*args)
      all_errors.map(&:last)
    end

    def self.errors_on(cycle, have_matrix_errors)
      errors = []
      
      if !cycle.priorities_approved?
        errors.push(["Priorities must be approved."])
      end

      if have_matrix_errors
        errors.push(["Work analysis matrix have errors. (See below)"])
      end

      errors
    end
  end
end

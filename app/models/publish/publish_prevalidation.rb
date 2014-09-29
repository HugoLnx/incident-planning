module Publish
  class PublishPrevalidation
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
        errors.push(["Work analysis matrix have errors. (See below)"])
      end

      errors
    end
  end
end

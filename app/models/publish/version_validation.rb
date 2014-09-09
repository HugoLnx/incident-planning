module Publish
  module VersionValidation
    extend self

    def msg(errorkey)
      I18n.t("errors.messages.#{errorkey}")
    end

    EXCLUDED_VALIDATIONS = {
      how: [msg(:approved)],
      expression: [msg(:approved)],
      where_text: [PublishValidation::ITEM_EMPTY_MESSAGE],
      when_text: [PublishValidation::ITEM_EMPTY_MESSAGE]
    }

    def errors_messages_on(objectives_groups, disable_approvals: false)
      all_errors = errors_on(objectives_groups, disable_approvals: disable_approvals)
      ValidationUtils.errors_messages_from_errors(all_errors)
    end

    def errors_on(objectives_groups, disable_approvals: false)
      all_errors = PublishValidation.errors_on(objectives_groups, disable_approvals: disable_approvals)

      Validation::Utils::ErrorsCleaner.clear(all_errors[:expression][:text], criteria: EXCLUDED_VALIDATIONS)
      Validation::Utils::ErrorsCleaner.clear(all_errors[:expression][:time], criteria: EXCLUDED_VALIDATIONS)

      return all_errors
    end
  end
end

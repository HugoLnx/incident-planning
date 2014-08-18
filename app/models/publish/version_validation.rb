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

    def errors_messages_on(objectives_groups)
      all_errors = errors_on(objectives_groups)
      ValidationUtils.errors_messages_from_errors(all_errors)
    end

    def errors_on(objectives_groups)
      all_errors = PublishValidation.errors_on(objectives_groups)

      clear(all_errors[:expression][:text])
      clear(all_errors[:expression][:time])

      return all_errors
    end

  private
    def clear(exp_errors)
      exp_errors.each do |_, exp_errors|
        exp_errors.delete_if do |(field, msg)|
          excluded_msgs = EXCLUDED_VALIDATIONS[field]
          delete = excluded_msgs && excluded_msgs.include?(msg)
          delete
        end
      end

      exp_errors.keys.each do |exp_id|
        exp_errors.delete(exp_id) if exp_errors[exp_id].empty?
      end
    end
  end
end

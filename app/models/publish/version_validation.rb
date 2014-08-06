module Publish
  class VersionValidation
    EXCLUDED_VALIDATIONS = {
      how: [:approved],
      expression: [:approved]
    }.each do |_, value|
      value.map!{|name| I18n.t("errors.messages.#{name}")}
    end


    def self.errors_on(objectives_groups)
      all_errors = PublishValidation.errors_on(objectives_groups)

      exp_errors = all_errors[:expression]
      exp_errors.each do |_, exp_errors|
        exp_errors.delete_if do |(field, msg)|
          excluded_msgs = EXCLUDED_VALIDATIONS[field]
          excluded_msgs && excluded_msgs.include?(msg)
        end
      end

      exp_errors.keys.each do |exp_id|
        exp_errors.delete(exp_id) if exp_errors[exp_id].empty?
      end

      return all_errors
    end
  end
end

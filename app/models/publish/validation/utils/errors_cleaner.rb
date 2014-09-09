module Publish
  module Validation
    module Utils
      module ErrorsCleaner
        extend self

        def msg(errorkey)
          I18n.t("errors.messages.#{errorkey}")
        end

        EXCLUDE_APPROVALS =  {
          how: [msg(:approved)],
          expression: [msg(:approved)],
          objective: [msg(:approved)]
        }

        def clear(exp_errors, criteria: [])
          exp_errors.each do |_, exp_errors|
            exp_errors.delete_if do |(field, msg)|
              excluded_msgs = criteria[field]
              delete = excluded_msgs && excluded_msgs.include?(msg)
              delete
            end
          end

          exp_errors.keys.each do |exp_id|
            exp_errors.delete(exp_id) if exp_errors[exp_id].empty?
          end
        end

        def clear_approvals(exp_errors)
          clear(exp_errors, criteria: EXCLUDE_APPROVALS)
        end
      end
    end
  end
end

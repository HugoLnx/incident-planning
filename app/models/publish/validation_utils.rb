module Publish
  module ValidationUtils
    extend self

    def errors_messages_from_errors(all_errors)
      text_messages = Publish::ValidationUtils.get_messages(all_errors[:expression][:text])
      time_messages = Publish::ValidationUtils.get_messages(all_errors[:expression][:time])
      group_messages = Publish::ValidationUtils.get_messages(all_errors[:group])
      group_messages = Publish::GroupMessagesIterator.new(group_messages)

      return {
        expression: {
          text: text_messages,
          time: time_messages
        },
        group: group_messages
      }
    end

    def get_messages(errors)
      messages = Hash.new([])
      errors.each do |key, exp_errors|
        messages[key] = exp_errors.map(&:last).flatten.map(&:capitalize)
      end
      messages
    end

    def have_errors?(all_messages)
      all_messages[:group] && !all_messages[:group].empty? || (
        all_messages[:expression] && (
          all_messages[:expression][:text] && !all_messages[:expression][:text].empty? ||
          all_messages[:expression][:time] && !all_messages[:expression][:time].empty?
        )
      )
    end
  end
end

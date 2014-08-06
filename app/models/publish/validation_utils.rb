module Publish
  module ValidationUtils
    extend self

    def get_messages(errors)
      messages = Hash.new([])
      errors.each do |key, exp_errors|
        messages[key] = exp_errors.map(&:last).flatten.map(&:capitalize)
      end
      messages
    end
  end
end

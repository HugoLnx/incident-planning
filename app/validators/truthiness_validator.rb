class TruthinessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value
      record.errors.add(attribute, options[:message] || :truthiness)
    end
  end
end

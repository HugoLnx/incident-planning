class NotEmptyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && value.empty?
      record.errors.add(attribute, options[:message] || :not_empty)
    end
  end
end

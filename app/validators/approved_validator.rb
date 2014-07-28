class ApprovedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, expression)
    if expression && expression.status != TextExpression::STATUS.approved()
      record.errors.add(attribute, options[:message] || :approved)
    end
  end
end

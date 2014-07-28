class AnyBlankElementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, collection)
    if valid?(collection)
      record.errors.add(attribute, options[:message] || :any_blank_element)
    end
  end

private

  def valid?(collection)
    collection && collection.any? do |element|
      element = options[:method] ? element.public_send(options[:method]) : element
      blank?(element)
    end
  end

  def blank?(element)
    element && (element.nil? || element.empty?)
  end
end

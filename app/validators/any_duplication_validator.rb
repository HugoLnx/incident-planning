class AnyDuplicationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, collection)
    if valid?(collection)
      record.errors.add(attribute, options[:message] || :any_duplication)
    end
  end

private

  def valid?(collection)
    if collection
      collection = collection.map(&(options[:method])) if options[:method]
      
      return have_duplication?(collection)
    end
    return false
  end

  def have_duplication?(collection)
    collection = collection.dup

    while !collection.empty?
      element = collection.pop
      if !element.blank? && collection.include?(element)
        return true
      end
    end

    return false
  end
end

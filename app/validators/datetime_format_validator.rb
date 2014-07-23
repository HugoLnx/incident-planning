class DatetimeFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    format = options[:with]
    begin
      DateTime.strptime(value, format)
    rescue ArgumentError => e
      record.errors.add(attribute, :date_format, dateformat: format)
    end
  end
end

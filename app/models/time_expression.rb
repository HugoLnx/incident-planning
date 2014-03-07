class TimeExpression < ActiveRecord::Base
  include Concerns::Expression

  TIME_PARSING_FORMAT = "%d/%m/%Y %H:%M"

  def info_as_str
    self.when.strftime TIME_PARSING_FORMAT
  end
end

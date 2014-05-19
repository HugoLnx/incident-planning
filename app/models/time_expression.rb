class TimeExpression < ActiveRecord::Base
  include Concerns::Expression
  belongs_to :reused_expression, class_name: ::TimeExpression

  TIME_PARSING_FORMAT = "%d/%m/%Y %H:%M"

  def info_as_str
    if self.when
      self.when.strftime TIME_PARSING_FORMAT
    else
      self.text
    end
  end

  def content_changed?
    when_changed?
  end
end

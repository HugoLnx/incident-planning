class TextExpression < ActiveRecord::Base
  include Concerns::Expression
  belongs_to :reused_expression, class_name: ::TextExpression

  def info_as_str
    if reused_expression
      reused_expression.info_as_str
    else
      text
    end
  end

  def content_changed?
    text_changed?
  end
end

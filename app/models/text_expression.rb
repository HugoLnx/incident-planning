class TextExpression < ActiveRecord::Base
  include Concerns::Expression
  belongs_to :reused_expression, class_name: ::TextExpression

  def info_as_str
    text
  end

  def content_changed?
    text_changed?
  end
end

class TextExpression < ActiveRecord::Base
  include Concerns::Expression

  def info_as_str
    text
  end

  def content_changed?
    text_changed?
  end
end

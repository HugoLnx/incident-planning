class TextExpression < ActiveRecord::Base
  include Concerns::Expression

  def info_as_str
    text
  end
end

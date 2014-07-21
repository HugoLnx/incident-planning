class TextExpression < ActiveRecord::Base
  include Concerns::Expression

  def info_as_str
    text
  end

  def content_changed?
    text_changed?
  end

  def self.objectives_of_cycle(cycle_id)
    TextExpression.objectives.joins(group: :cycle).where(cycle_id: cycle_id).load
  end
end

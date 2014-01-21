class TextExpression < ActiveRecord::Base
  belongs_to :cycle

  def self.new_objective(text)
    self.new(text: text, hierarchical_path: Model.objective.path)
  end
end

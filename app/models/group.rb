class Group < ActiveRecord::Base
  has_many :text_expressions, class_name: ::TextExpression
  has_many :time_expressions, class_name: ::TimeExpression

  belongs_to :father, class_name: ::Group
  has_many :childs, class_name: ::Group, foreign_key: "father_id"

  belongs_to :cycle

  validates :cycle_id, presence: true

  validates_associated :cycle

  def expressions
    self.text_expressions + self.time_expressions
  end
end

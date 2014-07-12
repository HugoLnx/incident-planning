class Group < ActiveRecord::Base
  has_many :text_expressions, class_name: ::TextExpression, dependent: :destroy
  has_many :time_expressions, class_name: ::TimeExpression, dependent: :destroy

  belongs_to :father, class_name: ::Group
  has_many :childs, class_name: ::Group, foreign_key: "father_id", dependent: :destroy

  belongs_to :cycle

  validates :cycle_id, presence: true

  validates_associated :cycle

  default_scope {order "created_at ASC"}

  def self.childs_of_father_of_text_expression(exp_id)
    joins(father: :text_expressions).where("text_expressions.id" => exp_id)
  end

  def expressions
    self.text_expressions + self.time_expressions
  end
end

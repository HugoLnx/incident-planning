class Group < ActiveRecord::Base
  has_many :text_expressions, class_name: ::TextExpression, dependent: :destroy
  has_many :time_expressions, class_name: ::TimeExpression, dependent: :destroy

  belongs_to :father, class_name: ::Group
  has_many :childs, class_name: ::Group, foreign_key: "father_id", dependent: :destroy

  belongs_to :cycle

  validates :cycle_id, presence: true

  validates :criticality, inclusion: {
    in: %w{L M H},
    if: :tactic?
  }

  validates_associated :cycle

  default_scope {order "created_at ASC"}

  after_initialize :defaults

  IDENTIFYING_NAMES = [::Model.tactic_who.name, ::Model.tactic_what.name, ::Model.tactic_where.name]

  def self.childs_of_father_of_text_expression(exp_id)
    joins(father: :text_expressions).where("text_expressions.id" => exp_id)
  end

  def self.father_of_expression(exp_id)
    joins(:text_expressions)
      .where("text_expressions.id" => exp_id)
  end

  def expressions
    self.text_expressions + self.time_expressions
  end

  def duplication?(group)
    if self.name != group.name
      return false
    end

    if self.name == ::Model.tactic.name
      names = IDENTIFYING_NAMES
      my_texts = self.text_expressions.where("name IN (?, ?, ?)", *names).to_a.map(&:text)
      it_texts = group.text_expressions.where("name IN (?, ?, ?)", *names).to_a.map(&:text)
    else
      my_texts = [self.text_expressions.first.text]
      it_texts = [group.text_expressions.first.text]
    end

    return !my_texts.any?(&:nil?) &&
    !it_texts.any?(&:nil?) &&
    !my_texts.any?(&:empty?) &&
    !it_texts.any?(&:empty?) &&
    my_texts == it_texts
  end

  def tactic?
    self.name == ::Model.tactic.name
  end

private

  def defaults
    self.criticality ||= 'L'
  end
end

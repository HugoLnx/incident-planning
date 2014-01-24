class Group < ActiveRecord::Base
  has_many :text_expressions, class_name: ::TextExpression
  has_many :time_expressions, class_name: ::TimeExpression

  belongs_to :father, class_name: ::Group
  has_many :childs, class_name: ::Group, foreign_key: "father_id"

  belongs_to :cycle
end

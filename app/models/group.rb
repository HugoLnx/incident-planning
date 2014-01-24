class Group < ActiveRecord::Base
  has_many :text_expressions
  has_many :time_expressions

  belongs_to :expression, polymorphic: true
end

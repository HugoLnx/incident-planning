class Cycle < ActiveRecord::Base
  belongs_to :incident

  has_many :text_expressions
  has_many :time_expressions
  has_many :groups, class_name: ::Group
end

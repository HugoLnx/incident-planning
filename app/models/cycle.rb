class Cycle < ActiveRecord::Base
  belongs_to :incident

  has_many :text_expressions
end

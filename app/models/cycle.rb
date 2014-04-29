class Cycle < ActiveRecord::Base
  belongs_to :incident

  has_many :text_expressions
  has_many :time_expressions
  has_many :groups, class_name: ::Group

  def self.next_number_to(incident)
    (incident.cycles.maximum(:number) || 0) + 1
  end
end

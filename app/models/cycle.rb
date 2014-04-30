class Cycle < ActiveRecord::Base
  belongs_to :incident

  has_many :text_expressions
  has_many :time_expressions
  has_many :groups, class_name: ::Group

  def self.next_have_ending_mandatory?(incident)
    incident.cycles.exists?
  end

  def self.next_number_to(incident)
    (incident.cycles.maximum(:number) || 0) + 1
  end

  def self.next_dates_limits_to(incident)
    last_cycle = incident.cycles.last
    if last_cycle
      beggining = last_cycle.to
      ending = beggining + last_cycle.datetimes_difference
    else
      current_date = DateTime.now
      beggining = current_date
      ending = current_date.next_day 1
    end
    beggining..ending
  end

  def datetimes_difference
    to - from
  end
end

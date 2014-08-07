class Version < ActiveRecord::Base
  FIRST_NUMBER = 1

  belongs_to :cycle

  def self.new_next_to(cycle)
    Version.new number: self.next_number_to(cycle), cycle: cycle
  end

  def self.next_number_to(cycle)
    last_version = cycle.last_version
    if last_version.nil?
      return FIRST_NUMBER
    else
      return last_version.number + 1
    end
  end
end

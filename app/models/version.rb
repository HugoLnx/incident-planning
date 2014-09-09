class Version < ActiveRecord::Base
  FIRST_NUMBER = 1

  belongs_to :cycle
  belongs_to :user

  validates :ics234_pdf,
    presence: true

  validates :ics202_pdf,
    presence: true

  def self.new_next_to(cycle)
    next_number = self.next_number_to(cycle)
    Version.new number: next_number, cycle: cycle
  end

  def self.next_number_to(cycle)
    last_version = cycle.last_version
    if last_version.nil?
      return FIRST_NUMBER
    else
      return last_version.number + 1
    end
  end

  def final?
    self.cycle.closed? && self == cycle.last_version
  end
end

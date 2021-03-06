class Cycle < ActiveRecord::Base
  FIRST_NUMBER = 1

  belongs_to :incident

  has_many :text_expressions
  has_many :time_expressions
  has_many :groups, class_name: ::Group
  has_many :versions

  default_scope {order "number ASC"}

  before_destroy :destroy_objectives

  def self.next_have_ending_mandatory?(incident)
    incident.cycles.exists?
  end

  def self.next_number_to(incident)
    last_number = incident.cycles.maximum(:number)
    if last_number.nil?
      return FIRST_NUMBER
    else
      return last_number + 1
    end
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

  def approved?
    is_objectives_approved = (text_expressions.objectives).all?{|exp| exp.status == TextExpression::STATUS.approved}
    is_objectives_approved && priorities_approved?
  end

  def priorities_approved?
    priorities_approval_status
  end

  def approve_all_objectives!(user)
    objectives = text_expressions.objectives.includes(:approvals)
    approvals = ApprovalCollection.new
    objectives.each do |objective|
      new_approvals = Approval.build_all_to(user, positive: true, approve: objective)
      approvals += new_approvals
    end

    ActiveRecord::Base.transaction(requires_new: true) do
      approvals.save! && self.update!(priorities_approval_status: true)
    end
  end

  def approve_all_objectives(user)
    begin
      self.approve_all_objectives!(user)
      return true
    rescue ActiveRecord::ActiveRecordError
      return false
    end
  end

  def destroy_objectives
    groups.where(name: "Objective").destroy_all
  end

  def next_to_be_published?
    number == FIRST_NUMBER || before_me.published?
  end

  def before_me
    Cycle.where("incident_id = ? AND number < ?", self.incident_id, self.number).last
  end

  def changed_after_last_version?
    ver = last_version
    if last_version
      last_change = [
        self.updated_at, self.text_expressions.maximum(:updated_at),
        self.time_expressions.maximum(:updated_at),
        self.groups.maximum(:updated_at)
      ].max

      last_change > last_version.updated_at
    else
      true
    end
  end

  def published?
    closed?
  end

  def last_version
    versions.order(:created_at).last
  end

  def last_non_final_version
    if published?
      versions.order(:created_at)[-2]
    else
      versions.order(:created_at).last
    end
  end

  def current_version_number
    if self.published?
      version = self.last_version
      version.nil? ? Version::FIRST_NUMBER : version.number
    else
      Version.next_number_to(self)
    end
  end

  def have_past_versions?
    versions.count != 0
  end

  def update_priorities(new_priorities)
    if self.priorities != new_priorities
      self.priorities_approval_status = false
    end
    self.priorities = new_priorities
  end
end

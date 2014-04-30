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
end

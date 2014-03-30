require 'forwardable'

class ApprovalCollection
  extend Forwardable

  def_delegators :@approvals, :[], :each

  def initialize(approvals)
    @approvals = approvals
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        @approvals.each(&:save!)
      end
      return true
    rescue ActiveRecord::ActiveRecordError
      return false
    end
  end
end

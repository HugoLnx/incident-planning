require 'forwardable'

class ApprovalCollection
  extend Forwardable

  def_delegators :@approvals, :[], :each

  def initialize(approvals=[])
    @approvals = approvals
  end

  def save!
    ActiveRecord::Base.transaction(requires_new: true) do
      @approvals.each(&:save!)
    end
  end

  def save
    begin
      self.save!

      return true
    rescue ActiveRecord::ActiveRecordError
      return false
    end
  end
  
  def +(approval_collection)
    ApprovalCollection.new(self.to_a + approval_collection.to_a)
  end

  def to_a
    @approvals
  end
end

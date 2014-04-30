class ChangeCyclePrioritiesApprovalStatusToBeFalseByDefault < ActiveRecord::Migration
  def change
    change_column :cycles, :priorities_approval_status, :boolean, default: false, null: false
  end
end

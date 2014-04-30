class AddPrioritiesApprovalStatusToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :priorities_approval_status, :boolean
  end
end

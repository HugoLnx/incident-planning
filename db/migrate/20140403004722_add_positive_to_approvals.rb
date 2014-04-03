class AddPositiveToApprovals < ActiveRecord::Migration
  def change
    add_column :approvals, :positive, :boolean, null: false
    Approval.update_all(positive: true)
  end
end

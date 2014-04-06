class AddPositiveToApprovals < ActiveRecord::Migration
  def up
    add_column :approvals, :positive, :boolean
    Approval.update_all(positive: true)
    change_column :approvals, :positive, :boolean, null: false
  end

  def down
    remove_column :approvals, :positive
  end
end

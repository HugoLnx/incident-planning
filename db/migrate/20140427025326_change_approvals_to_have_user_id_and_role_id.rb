class ChangeApprovalsToHaveUserIdAndRoleId < ActiveRecord::Migration
  def up
    add_column :approvals, :user_id, :integer, null: false
    add_column :approvals, :role_id, :integer, null: false

    add_index :approvals, :user_id, using: :btree
    add_index :approvals, :role_id, using: :btree

    remove_index :approvals, :user_role_id
    remove_column :approvals, :user_role_id
  end

  def down
    remove_index :approvals, :user_id
    remove_index :approvals, :role_id

    remove_column :approvals, :user_id
    remove_column :approvals, :role_id

    add_column :approvals, :user_role_id, :integer, null: false
    add_index :approvals, :user_role_id, using: :btree
  end
end

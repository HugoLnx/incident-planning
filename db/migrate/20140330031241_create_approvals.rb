class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer :user_role_id
      t.references :expression, index: false, polymorphic: true

      t.timestamps
    end

    add_index :approvals, :user_role_id, using: :btree
    add_index :approvals, :expression_id, using: :btree
    add_index :approvals, :expression_type, using: :btree
  end
end

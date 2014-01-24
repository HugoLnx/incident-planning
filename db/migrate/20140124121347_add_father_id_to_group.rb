class AddFatherIdToGroup < ActiveRecord::Migration
  def change
    remove_column :groups, :expression_id, :integer
    remove_column :groups, :expression_type, :integer
    add_column :groups, :father_id, :integer
    add_column :groups, :cycle_id, :integer, null: false

    add_index :groups, :father_id
    add_index :groups, :cycle_id
  end
end

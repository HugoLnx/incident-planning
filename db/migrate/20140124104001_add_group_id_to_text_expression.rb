class AddGroupIdToTextExpression < ActiveRecord::Migration
  def change
    add_column :text_expressions, :group_id, :integer
    add_index :text_expressions, :group_id
  end
end

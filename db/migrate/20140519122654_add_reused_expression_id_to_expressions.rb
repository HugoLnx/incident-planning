class AddReusedExpressionIdToExpressions < ActiveRecord::Migration
  def up
    add_column :text_expressions, :reused_expression_id, :integer
    add_column :time_expressions, :reused_expression_id, :integer

    add_index :text_expressions, :reused_expression_id, using: :btree
    add_index :time_expressions, :reused_expression_id, using: :btree
  end

  def down
    remove_column :text_expressions, :reused_expression_id
    remove_column :time_expressions, :reused_expression_id
  end
end

class RenameHierarchicalPathToNameOnExpressions < ActiveRecord::Migration
  def change
    rename_column :text_expressions, :hierarchical_path, :name
    rename_column :time_expressions, :hierarchical_path, :name
  end
end

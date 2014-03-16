class MetadataToExpressions < ActiveRecord::Migration
  def up
    add_column :text_expressions, :owner_id, :integer
    add_column :time_expressions, :owner_id, :integer

    add_index :text_expressions, :owner_id
    add_index :time_expressions, :owner_id
  end

  def down
    remove_column :text_expressions, :owner_id
    remove_column :time_expressions, :owner_id
  end
end

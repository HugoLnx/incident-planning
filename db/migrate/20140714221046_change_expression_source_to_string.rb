class ChangeExpressionSourceToString < ActiveRecord::Migration
  def up
    remove_column :text_expressions, :source
    remove_column :time_expressions, :source
    add_column :text_expressions, :source, :string
    add_column :time_expressions, :source, :string
  end

  def down
    remove_column :text_expressions, :source
    remove_column :time_expressions, :source
    add_column :text_expressions, :source, :integer, limit: 8, default: 0, null: false
    add_column :time_expressions, :source, :integer, limit: 8, default: 0, null: false
  end
end

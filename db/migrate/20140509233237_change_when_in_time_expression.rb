class ChangeWhenInTimeExpression < ActiveRecord::Migration
  def up
    change_column :time_expressions, :when, :datetime, null: true
  end

  def down
    change_column :time_expressions, :when, :datetime, null: false
  end
end

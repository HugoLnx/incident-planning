class AddCycleIdToTimeExpression < ActiveRecord::Migration
  def change
    add_column :time_expressions, :cycle_id, :integer
    add_index :time_expressions, :cycle_id
  end
end

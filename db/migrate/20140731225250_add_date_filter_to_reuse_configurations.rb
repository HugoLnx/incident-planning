class AddDateFilterToReuseConfigurations < ActiveRecord::Migration
  def change
    add_column :reuse_configurations, :date_filter, :integer
  end
end

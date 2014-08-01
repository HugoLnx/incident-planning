class AddEnabledToReuseConfigurations < ActiveRecord::Migration
  def change
    add_column :reuse_configurations, :enabled, :boolean, default: true
  end
end

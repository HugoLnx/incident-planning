class FeaturesConfigOnlyWithThesisTools < ActiveRecord::Migration
  def up
    add_column :features_configs, :thesis_tools, :boolean, null: false, default: true
    remove_column :features_configs, :authority_control
    remove_column :features_configs, :traceability
  end

  def down
    remove_column :features_configs, :thesis_tools
    add_column :features_configs, :authority_control, :boolean, null: false, default: true
    add_column :features_configs, :traceability, :boolean, null: false, default: true
  end
end

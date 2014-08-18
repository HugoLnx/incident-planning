class RenameFeaturesConfigAutorityControlToAuthorityControl < ActiveRecord::Migration
  def change
    rename_column :features_configs, :autority_control, :authority_control
  end
end

class CreateFeaturesConfigWithAutorityControlAndTraceabilityAndUserId < ActiveRecord::Migration
  def change
    create_table :features_configs do |t|
      t.boolean :autority_control, null: false, default: true
      t.boolean :traceability, null: false, default: true
      t.integer :user_id
    end
    add_index :features_configs, :user_id, using: :hash
  end
end

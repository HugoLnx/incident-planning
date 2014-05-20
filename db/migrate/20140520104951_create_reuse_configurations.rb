class CreateReuseConfigurations < ActiveRecord::Migration
  def up
    create_table :reuse_configurations do |t|
      t.boolean :hierarchy, default: true
      t.string :user_filter_type, null: false, default: "all"
      t.string :user_filter_value
      t.string :incident_filter_type, null: false, default: "all"
      t.string :incident_filter_value
      t.integer :user_id, null: false
    end

    add_index :reuse_configurations, :user_id, using: :hash
  end

  def down
    drop_table :reuse_configurations
  end
end

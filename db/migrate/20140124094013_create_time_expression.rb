class CreateTimeExpression < ActiveRecord::Migration
  def change
    create_table :time_expressions do |t|
      t.datetime :when, null: false
      t.string :hierarchical_path, null: false
      t.integer :group_id

      t.timestamps
    end

    add_index :time_expressions, :group_id
  end
end

class CreateTextExpressionTable < ActiveRecord::Migration
  def change
    create_table :text_expressions do |t|
      t.string :hierarchical_path, null: false
      t.string :text, null: false
      t.references :cycle, null: false

      t.timestamps
    end

    add_index :text_expressions, :cycle_id
  end
end

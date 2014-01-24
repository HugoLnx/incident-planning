class CreateGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :expression_id
      t.string :expression_type
      t.string :name, null: false

      t.timestamps
    end

    add_index :groups, :expression_id
    add_index :groups, :expression_type
  end
end

class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.integer :incident_id, null: false
      t.integer :number, null: false
      t.integer :current_object, null: false
      t.datetime :from, null: false
      t.datetime :to, null: false
      t.boolean :closed, default: false

      t.timestamps
    end
  end
end

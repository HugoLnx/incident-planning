class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.integer :incident_id
      t.integer :number
      t.integer :current_object
      t.datetime :from
      t.datetime :to
      t.boolean :closed

      t.timestamps
    end
  end
end

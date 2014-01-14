class CreatePlannings < ActiveRecord::Migration
  def change
    create_table :plannings do |t|
      t.string :incident_name
      t.text :priorities_list
      t.date :from
      t.date :to
      t.integer :cycle

      t.timestamps
    end
  end
end

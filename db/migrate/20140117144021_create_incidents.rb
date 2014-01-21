class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

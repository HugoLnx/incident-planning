class CreateVersionsWithNumberAndCycleId < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :number
      t.integer :cycle_id

      t.timestamps
    end

    add_index :versions, :cycle_id, using: :hash
  end
end

class AddCriticalityToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :criticality, :string
  end
end

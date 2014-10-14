class AddCompanyIdToIncident < ActiveRecord::Migration
  def change
    add_column :incidents, :company_id, :integer
    add_index :incidents, :company_id
  end
end

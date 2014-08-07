class AddPdfToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :pdf, :binary, limit: 3.megabyte, null: false
  end
end

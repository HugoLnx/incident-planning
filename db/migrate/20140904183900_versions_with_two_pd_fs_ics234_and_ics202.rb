class VersionsWithTwoPdFsIcs234AndIcs202 < ActiveRecord::Migration
  def up
    rename_column :versions, :pdf, :ics234_pdf
    add_column :versions, :ics202_pdf, :binary, null: false
  end

  def down
    rename_column :versions, :ics234_pdf, :pdf
    remove_column :versions, :ics202_pdf
  end
end

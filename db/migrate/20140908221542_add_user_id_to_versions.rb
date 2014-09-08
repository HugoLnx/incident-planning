class AddUserIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :user_id, :integer
    add_index :versions, :user_id, using: :hash
  end
end

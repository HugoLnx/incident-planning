class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
    end

    add_index :user_roles, :user_id, using: :btree
  end
end

class AddNameAndPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string, limit: 25
  end
end

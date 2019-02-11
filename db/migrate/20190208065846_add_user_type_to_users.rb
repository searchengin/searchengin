class AddUserTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :user_type, :integer, default: 0
    add_column :users, :handle, :string, unique: true
  end
end


class AddKeyfsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :keyfs, :string
  end
end

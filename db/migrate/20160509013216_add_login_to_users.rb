class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :logged_in, :boolean
  end
end

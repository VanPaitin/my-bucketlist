class AddDefaultValueToLoggedIn < ActiveRecord::Migration
  def change
    change_column_default :users, :logged_in, from: nil, to: false
  end
end

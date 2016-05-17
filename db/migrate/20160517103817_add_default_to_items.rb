class AddDefaultToItems < ActiveRecord::Migration
  def change
    change_column_default :items, :done, from: nil, to: false
  end
end

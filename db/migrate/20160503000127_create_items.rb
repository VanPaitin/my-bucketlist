class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :name
      t.boolean :done
      t.references :bucketlist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

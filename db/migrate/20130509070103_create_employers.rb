class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name, :null => false
      t.boolean :is_deleted, :default => false, :null => false
      t.timestamps

      t.index :name, :unique => true
    end
  end
end

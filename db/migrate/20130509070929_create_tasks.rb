class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, :null => false
      t.string :description, :default => nil, :null => true
      t.boolean :is_deleted, :default => false, :null => false
      t.timestamps

      t.index :name, :unique => true
    end
  end
end

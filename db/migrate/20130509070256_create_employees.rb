class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :user_id, :null => false
      t.integer :employer_id, :null => false
      t.boolean :is_manager, :default => false, :null => false
      t.timestamps

      t.index :user_id
      t.index :employer_id
      t.index [:user_id, :employer_id], :unique => true
    end
  end
end

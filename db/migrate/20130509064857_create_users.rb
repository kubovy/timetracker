class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false
      t.string :email, :default => nil, :null => true
      t.boolean :is_admin, :default => false, :null => false
      t.boolean :is_manager, :default => false, :null => false
      t.string :remember_token, :default => nil, :null => true
      t.boolean :is_deleted, :default => false, :null => false
      t.timestamps

      t.index :login, :unique => true
      t.index :email, :unique => true
      t.index :remember_token
    end
  end
end

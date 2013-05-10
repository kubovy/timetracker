class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
	    t.integer :employer_id, :null => false
      t.string :name, :null => false
      t.string :description, :null => false
      t.integer :owner_id, :null => false
      t.boolean :is_deleted, :default => false, :null => false
      t.timestamps

      t.index [:employer_id, :name], :unique => true
    end
  end
end

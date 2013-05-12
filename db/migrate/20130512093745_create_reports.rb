class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
	    t.integer :user_id, :null => false
	    t.string :name, :null => false
	    t.string :project_ids, :null => false, :default => ''
	    t.string :task_ids, :null => false, :default => ''
	    t.string :user_ids, :null => false, :default => ''
	    t.integer :time_period, :null => true, :default => nil
	    t.date :start, :null => true, :default => nil
	    t.date :end, :null => true, :default => nil
	    t.string :fields, :null => false, :default => ''
	    t.integer :group_by, :null => true, :default => nil
	    t.integer :group_per, :null => true, :default => nil

	    t.timestamps

	    t.index :user_id
	    t.index :name
	    t.index [:user_id, :name], :unique => true
    end
  end
end

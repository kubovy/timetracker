class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
	    t.integer :employer_id, :null => false
	    t.integer :team_id, :null => true, :default => nil
	    t.integer :user_id, :null => false

	    t.integer :client_id, :null => true, :default => nil
	    t.integer :invoice_id, :null => true, :default => nil

	    t.integer :project_id, :null => false
	    t.integer :task_id, :null => false

	    t.date :date, :null => false
	    t.time :start, :null => false
	    t.time :duration, :null => false

	    t.text :description, :null => false
	    t.boolean :billable, :null => false, :default => true

      t.timestamps

	    t.index :employer_id
	    t.index :team_id
	    t.index :user_id
	    t.index :client_id
	    t.index :invoice_id
	    t.index :project_id
	    t.index :task_id
	    t.index :date
	    t.index :start
	    t.index :duration
	    t.index :billable
    end
  end
end

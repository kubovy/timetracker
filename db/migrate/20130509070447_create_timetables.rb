class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :employer_id, :null => false
      t.integer :employee_id, :null => false
      t.integer :day, :null => false
      t.time :hours, :null => false
      t.timestamps

      t.index [:employer_id, :employee_id, :day], :unique => true
    end
  end
end

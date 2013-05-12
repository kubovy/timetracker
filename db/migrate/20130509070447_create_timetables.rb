class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :employer_id, :null => false
      t.integer :user_id, :null => false
      t.integer :day, :null => false
      t.time :hours, :null => false
      t.timestamps

      t.index [:employer_id, :user_id, :day], :unique => true
    end
  end
end

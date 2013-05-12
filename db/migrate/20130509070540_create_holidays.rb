class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.integer :employer_id, :null => false
      t.date :date, :null => false
      t.timestamps

      t.index [:employer_id, :date], :unique => true
    end
  end
end

class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :employer_id, :null => false
      t.string :name, :null => false
      t.boolean :is_deleted, :default => false, :null => false
      t.timestamps

      t.index [:employer_id, :name], :unique => true
    end
  end
end

class CreateTimesheets < ActiveRecord::Migration[6.0]
  def change
    create_table :timesheets do |t|
      t.date :start_date
      
      t.string :screen_shot
      
      t.integer :monday, :default => 0
      t.integer :tuesday, :default => 0
      t.integer :wednesday, :default => 0
      t.integer :thursday, :default => 0
      t.integer :friday, :default => 0
      t.integer :saturday, :default => 0
      t.integer :sunday, :default => 0
      
      t.integer :job_id
      t.integer :employee_id
      
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end

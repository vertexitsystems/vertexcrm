class CreateWorkDurations < ActiveRecord::Migration[6.0]
  def change
    create_table :work_durations do |t|
      t.integer :hours
      t.date :work_day
      t.integer :project_id

      t.timestamps
    end
  end
end

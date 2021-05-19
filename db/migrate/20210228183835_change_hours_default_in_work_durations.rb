class ChangeHoursDefaultInWorkDurations < ActiveRecord::Migration[6.0]
  def change
  	change_column_default :work_durations, :hours,0
  end
end

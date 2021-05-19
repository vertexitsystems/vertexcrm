class AddDefaultStatusForWorkDurations < ActiveRecord::Migration[6.0]
  def change
  	change_column_default :work_durations, :time_sheet_status,from: {:integer => 1},to:0
  end
end

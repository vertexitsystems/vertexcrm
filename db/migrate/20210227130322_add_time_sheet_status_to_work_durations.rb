class AddTimeSheetStatusToWorkDurations < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :time_sheet_status, :integer,default: 0
  end
end

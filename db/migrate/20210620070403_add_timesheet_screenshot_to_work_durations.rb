class AddTimesheetScreenshotToWorkDurations < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :timesheet_screenshot, :string
  end
end

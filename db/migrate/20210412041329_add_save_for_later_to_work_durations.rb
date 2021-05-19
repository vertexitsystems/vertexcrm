class AddSaveForLaterToWorkDurations < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :save_for_later, :boolean, default: false
  end
end

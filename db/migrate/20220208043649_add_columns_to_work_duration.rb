class AddColumnsToWorkDuration < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :rejection_message, :string
    add_column :work_durations, :status_read, :boolean
    
    add_column :employees, :job_id, :integer
  end
end

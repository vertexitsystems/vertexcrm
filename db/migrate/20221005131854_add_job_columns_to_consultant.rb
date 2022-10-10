class AddJobColumnsToConsultant < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :job_start_date, :date
    add_column :employees, :job_end_date,   :date
    add_column :employees, :job_end_reason, :string
    #add_column :employees, :employee_rate, :decimal

    add_column :work_durations, :job_id, :integer
    #add_column :work_durations, :employee_id, :integer

  end
end

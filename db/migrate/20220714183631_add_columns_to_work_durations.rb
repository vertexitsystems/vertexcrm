class AddColumnsToWorkDurations < ActiveRecord::Migration[6.0]
  #Patch: 72205 AA01
  def change
    add_column :work_durations, :sun, :integer, :default => -1
    add_column :work_durations, :mon, :integer, :default => -1
    add_column :work_durations, :tue, :integer, :default => -1
    add_column :work_durations, :wed, :integer, :default => -1
    add_column :work_durations, :thu, :integer, :default => -1
    add_column :work_durations, :fri, :integer, :default => -1
    add_column :work_durations, :sat, :integer, :default => -1
    
    add_column :work_durations, :contract_type , :string
    
    add_column :work_durations, :employer_rate, :integer
    add_column :work_durations, :consultant_rate, :integer
    add_column :work_durations, :job_rate, :integer
    
    add_column :work_durations, :posting_id, :integer
    
    add_column :work_durations, :account_manager_id, :integer
    
    add_column :postings, :posting_rate, :decimal
    add_column :postings, :designation, :string
  end
end

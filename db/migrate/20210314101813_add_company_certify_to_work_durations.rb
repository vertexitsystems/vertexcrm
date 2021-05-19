class AddCompanyCertifyToWorkDurations < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :company_certify, :boolean, :default => false
  end
end

class AddTimeCardCertifyToWorkDurations < ActiveRecord::Migration[6.0]
  def change
    add_column :work_durations, :time_card_certify, :boolean, :default => false
  end
end

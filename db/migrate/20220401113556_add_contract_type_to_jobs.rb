class AddContractTypeToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :contract_type, :integer
  end
end

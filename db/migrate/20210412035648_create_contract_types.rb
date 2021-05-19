class CreateContractTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_types do |t|
      t.integer :employer_id
      t.integer :employee_id
      t.integer :contract_type

      t.timestamps
    end
  end
end

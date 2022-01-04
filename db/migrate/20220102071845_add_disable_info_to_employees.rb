class AddDisableInfoToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :contract_type, :string
    
    add_column :employees, :visa_status, :string
    add_column :employees, :visa_expiry, :date
    
    add_column :employees, :disabled,       :boolean
    add_column :employees, :disable_reason, :string
    add_column :employees, :disable_date,   :date
    add_column :employees, :disable_notes,  :string
    
  end
end

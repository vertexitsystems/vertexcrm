class AddDocumentFieldsToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :passport, :string
    add_column :employees, :visa, :string
    add_column :employees, :state_id, :string
    add_column :employees, :i9, :string
    add_column :employees, :e_verify, :string
    add_column :employees, :w9, :string
    add_column :employees, :psa, :string
    add_column :employees, :voided_check_copy, :string
    
    
    add_column :profiles, :country,  :string
    add_column :profiles, :state,  :string
    add_column :profiles, :city,  :string
    add_column :profiles, :zip_code, :string
    
    add_column :profiles, :first_name, :string
    add_column :profiles, :middle_name, :string
    add_column :profiles, :last_name, :string
    
    add_column :projects, :vendor_rate, :integer
  end
end

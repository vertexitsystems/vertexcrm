class AddInfoToEmployers < ActiveRecord::Migration[6.0]
  def change
    
    #add_column :employers, :company_name, :string
    add_column :employers, :company_address, :string
    add_column :employers, :phone_number, :string
    add_column :employers, :fax_number, :string 
    add_column :employers, :company_email, :string
    add_column :employers, :company_website, :string
    add_column :employers, :contact_name, :string
    add_column :employers, :contact_designation, :string
    add_column :employers, :contact_number, :string
    add_column :employers, :contact_email, :string
    
    add_column :vendors, :company_name, :string
    add_column :vendors, :company_address, :string
    add_column :vendors, :phone_number, :string
    add_column :vendors, :fax_number, :string 
    add_column :vendors, :company_email, :string
    add_column :vendors, :company_website, :string
    add_column :vendors, :contact_name, :string
    add_column :vendors, :contact_designation, :string
    add_column :vendors, :contact_number, :string
    add_column :vendors, :contact_email, :string
    
    #create_join_table :employees, :clients
    #create_join_table :employees, :vendors
    #create_join_table :employees, :employers
    add_column :employees, :employer_id, :integer
    add_column :employees, :client_id, :integer
  end
end

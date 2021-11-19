class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      
      t.string :company_name
      t.string :company_address
      t.string :phone_number
      t.string :fax_number
      t.string :company_email
      t.string :company_website
      t.string :contact_name
      t.string :contact_designation
      t.string :contact_number
      t.string :contact_email
      
      t.timestamps
    end
  end
end

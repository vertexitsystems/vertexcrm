class AddW2FieldsToEmployeeTable < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :resume, :string
    add_column :employees, :new_hire_package, :string
    add_column :employees, :po, :string
    add_column :employees, :w2_contract, :string
    add_column :employees, :offer_letter, :string
    add_column :employees, :w4, :string
    add_column :employees, :direct_deposit_detail, :string
    add_column :employees, :emergency_contact_form, :string
  end
end

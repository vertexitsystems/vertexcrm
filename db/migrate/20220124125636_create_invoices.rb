class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_file
      t.integer :employee_id
      t.integer :employer_id
      t.date :payment_date
      t.boolean :payment_status, :null => false, :default => false
      t.string :payment_rejection_message

      t.timestamps
    end
  end
end

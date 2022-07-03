class ChangeInvoicePaymentStatusTypeToInteger < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :approval_status, :integer
    add_column :employees, :employer_rate, :integer
  end
end

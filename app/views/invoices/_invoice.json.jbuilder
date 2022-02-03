json.extract! invoice, :id, :invoice_file, :emplyee, :employer, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)

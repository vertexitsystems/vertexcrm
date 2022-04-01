json.extract! timesheet, :id, :start_date, :created_at, :updated_at
json.url timesheet_url(timesheet, format: :json)

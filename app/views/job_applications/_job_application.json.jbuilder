json.extract! job_application, :id, :email, :ph_no, :cover_letter, :created_at, :updated_at
json.url job_application_url(job_application, format: :json)

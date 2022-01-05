json.extract! profile, :id, :full_name, :created_at, :updated_at
json.url profile_url(profile, format: :json)

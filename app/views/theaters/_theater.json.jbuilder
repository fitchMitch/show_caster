json.extract! theater, :id, :theater_name, :location, :manager, :manager_phone
# json.extract! theater, :id, :theater_name, :location, :manager, :manager_phone, :created_at, :updated_at
json.url theater_url(theater, format: :json)

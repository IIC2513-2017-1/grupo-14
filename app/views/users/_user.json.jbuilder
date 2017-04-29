json.extract! user, :id, :name, :mail, :password, :role, :created_at, :updated_at
json.url user_url(user, format: :json)

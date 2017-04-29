json.extract! bet, :id, :name, :description, :deadline, :max_participants, :type, :min_bet, :max_bet, :created_at, :updated_at
json.url bet_url(bet, format: :json)

# frozen_string_literal: true

json.user do
  json.href api_v1_user_url(@user)
  json.id @user.id 
  json.mail @user.mail
  json.name @user.name
  json.bets_participating do
    json.array! @user.participations do |parti|
      json.href api_v1_bet_url(parti.bet_id)
      json.name parti.bet.name
      json.description parti.bet.description
      json.kind parti.bet.kind
      json.deadline parti.bet.deadline
      json.max_participants parti.bet.max_participants
      json.min_bet parti.bet.min_bet
      json.max_bet parti.bet.max_bet
      json.private parti.bet.private
    end
  end
end
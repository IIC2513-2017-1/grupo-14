# frozen_string_literal: true

json.bet do
  json.href api_v1_bet_url(@bet)
  json.id @bet.id
  json.name @bet.name
  json.description @bet.description
  json.kind @bet.kind
  json.deadline @bet.deadline
  json.max_participants @bet.max_participants
  json.min_bet @bet.min_bet
  json.max_bet @bet.max_bet
  json.private @bet.private
  json.choices do
    json.array! @bet.choices do |choice|
      json.id choice.id
      json.value choice.value
    end
  end
end
# frozen_string_literal: true

json.user do
  json.href api_v1_user_url(@user)
  json.id @user.id 
  json.name @user.name
  json.mail @user.mail  
  if ['admin'].include?(@current_user.role)
    json.role @user.role
  end
  json.bets_participating do
    json.array! @user.participations do |parti|
      if @user == @current_user or ['admin'].include?(@current_user.role)
        json.participation do
          json.participation_href api_v1_participation_url(parti.id)
          json.amount parti.amount
        end
        json.choice do
          json.id parti.choice.id
          json.value parti.choice.value
        end
      end
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
  if ['admin', 'mod'].include?(@current_user.role)
    accessible = @user.bets.active 
  else
    accessible = @user.bets.where('user_id = ?', @current_user.id) + (@user.bets.bettable(@current_user)) + (@user.bets.bettable_private(@current_user))
  end
  json.bets_created do
    json.array! accessible do |bet|
      json.href api_v1_bet_url(bet)
      json.name bet.name
      json.description bet.description
      json.kind bet.kind
      json.deadline bet.deadline
      json.max_participants bet.max_participants
      json.min_bet bet.min_bet
      json.max_bet bet.max_bet
      json.private bet.private
    end
  end
  json.friends do
    json.array! @user.friends do |friend|
      json.href api_v1_user_url(friend)
      json.id friend.id 
      json.mail friend.mail
      json.name friend.name
    end
  end
end
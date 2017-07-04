# frozen_string_literal: true

json.participation do
    json.id @participation.id
    json.amount @participation.amount
    json.user_id @participation.user.id
    json.choice do
    	json.id @participation.choice.id
    	json.value @participation.choice.value
    end
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
	end
end
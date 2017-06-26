module BetsHelper


	def participate_button(bet)
		return unless current_user
		return if bet.user == current_user
		return if current_user.role != 'regular'
		return if bet.deadline.to_date.past? or bet.deadline == Date.today
		participation = bet.participations.detect do |participation|
			participation.user.id == current_user.id
		end
		if participation
			link_to 'Withdraw', participation_path(participation), method: 'delete', class: 'delete'
		else
			link_to 'Participate', new_bet_participation_path(bet), class: 'round_button'
		end
	end

	def close_button(bet)
	 	return unless current_user 
	 	return unless current_user.role == 'admin' or bet.user == current_user or current_user.role == 'mod'
	 	return if has_winner(bet)
	 	if bet.deadline.to_date.past?
	 		link_to 'Close', new_bet_winners_path(bet), class: 'delete'
	 	end
	end

	def has_winner(bet)
		return bet.winner
	end

	def percentage_and_winnings(choice)
		participants = choice.bet.participations.count
		return unless participants > 0
		votes_for_this = choice.bet.participations.where(choice_id: choice.id).count
		percentage = (votes_for_this.to_f()/participants.to_f())*100
		total = 0
		choice.bet.participations.where.not(choice_id: choice.id).each do |parti|
			total += parti.amount
		end
		total
		winnings = total/(1 + choice.bet.participations.where(choice_id: choice.id).count)
		'(' + percentage.to_s() + '% of votes, ' + winnings.to_s() + ' points potential winnings)'
	end

end

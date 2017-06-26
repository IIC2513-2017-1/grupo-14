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

end

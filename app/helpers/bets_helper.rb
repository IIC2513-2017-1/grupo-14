module BetsHelper


	def participate_button(bet)
		return unless current_user
		return if bet.user == current_user
		return if current_user.role != 'regular'
		return if bet.deadline.to_date.past? or bet.deadline == Date.today
		friendship = current_user.friendships.detect do |relation|
			relation.friend_id == bet.user.id
		end
		participation = bet.participations.detect do |participation|
			participation.user.id == current_user.id
		end
		if bet.private and not(friendship)
			return
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
		votes_for_this = choice.bet.participations.where(choice: choice).count
		percentage = (votes_for_this.to_f()/participants.to_f())*100
		total = 0
		choice.bet.participations.where.not(choice_id: choice.id).each do |parti|
			total += parti.amount
		end
		total
		winnings = total/(1 + choice.bet.participations.where(choice_id: choice.id).count)
		'(' + percentage.to_i().to_s() + '% of votes, ' + winnings.to_s() + ' points expected winnings)'
	end

	def page_numbers(bets_per_page=5)
		if not current_user
			bet_count = @bets.active.not_private.count
		elsif current_user and current_user.role == 'regular'
			bet_count = @bets.bettable(current_user).count
		else
			bet_count = @bets.active.count
		end
		if bet_count >= 1
			page_count = 1 + (bet_count-1)/bets_per_page
			puts 'total bets'
			puts bet_count
			final_string = "<div class='page_list'> "
			final_string += link_to '<<', { controller: 'bets', action: 'paginate', pp: 1, pl: bets_per_page }, remote: true, class: 'round_button pagination', data: { type: 'json' }
			(1..page_count).each do |page_number|
				final_string += link_to page_number, { controller: 'bets', action: 'paginate', pp: page_number, pl: bets_per_page }, remote: true, class: 'round_button pagination page_'+page_number.to_s(), data: { type: 'json' }
			end
			final_string += link_to '>>', { controller: 'bets', action: 'paginate', pp: page_count, pl: bets_per_page }, remote: true, class: 'round_button pagination', data: { type: 'json' }
			final_string += "</div>"
			return raw(final_string)
		end
	end

end

module BetsHelper
	def close_button(bet)
	 	return unless current_user 
	 	return unless current_user.role == 'admin' or bet.user == current_user or current_user.role == 'mod'
	 	if bet.deadline.to_date.past?
	 		link_to 'Close', new_bet_winners_path(bet), class: 'delete'
	 	end
	end
end

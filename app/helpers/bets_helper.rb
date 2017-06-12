module BetsHelper

	def participate_button(bet)
		return unless current_user
		return if bet.user == current_user
		return if current_user.role != 'regular'
		return if bet.deadline.to_date.past? or bet.deadline.today?
		participation = bet.participations.detect do |participation|
			participation.user.id == current_user.id
		end
		if participation
			link_to 'Withdraw', participation_path(participation), method: 'delete', class: 'delete'
		else
			link_to 'Participate', new_bet_participation_path(bet), class: 'round_button'
		end
	end

end

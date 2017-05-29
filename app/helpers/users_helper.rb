module UsersHelper
	def request_button(user)
		return unless current_user
		return if user == current_user
		sent_request = user.incoming_requests.detect do |relation|
			relation.sender_id == current_user.id
		end
		if sent_request
			link_to 'Cancel friend request', friendship_request_path(sent_request), method: 'delete'
		else
			link_to 'Send friend request', user_friendship_requests_path(user), method: 'post'
		end
	end
	def accept_friendship(user)
		return unless current_user
		return if user == current_user
end

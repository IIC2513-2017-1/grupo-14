module UsersHelper

	def request_button(user)
		return unless current_user
		return if user == current_user
		return if current_user.friends.include?(user)
		sent_request = user.incoming_requests.detect do |relation|
			relation.sender_id == current_user.id
		end
		if sent_request
			link_to 'Cancel friend request', friendship_request_path(sent_request), method: 'delete'
		else
			link_to 'Send friend request', user_friendship_requests_path(user), method: 'post'
		end
	end

	def accept_friendship_button(user)
		return unless current_user
		return if @user != current_user
		return if user == current_user
		received_request = current_user.incoming_requests.detect do |relation|
			relation.sender_id == user.id
		end
		if received_request
			link_to 'Accept', user_friendships_path(user), method: 'post'
		end
	end

	def reject_friendship_button(user)
		return unless current_user
		return if @user != current_user
		return if user == current_user
		received_request = current_user.incoming_requests.detect do |relation|
			relation.sender_id == user.id
		end
		if received_request
			link_to 'Reject', friendship_request_path(received_request), method: 'delete'
		end
	end

	def destroy_friendship_button(user)
		return unless current_user
		return if @user != current_user
		return if user == current_user
		friendship = current_user.friendships.detect do |relation|
			relation.friend_id == user.id
		end
		if friendship
			link_to 'Remove', friendship_path(friendship), method: 'delete'
		end
	end
end

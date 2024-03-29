module UsersHelper

	def request_button(user)
		return unless current_user
		return if user == current_user
		return if current_user.friends.include?(user)
		sent_request = user.incoming_requests.detect do |relation|
			relation.sender_id == current_user.id and (relation.recipient_id == @user.id or current_user.id == @user.id)
		end
		received_request = current_user.incoming_requests.detect do |relation|
			relation.sender_id == user.id
		end
		if sent_request
			link_to 'Cancel friend request', friendship_request_path(sent_request), method: 'delete', id: 'f_request', class: 'delete f_request', remote: true, data: { type: 'json', 'user-id': user.id }
		elsif received_request and
			link_to 'Accept friend request', user_friendships_path(user), method: 'post', id: 'f_request', class: 'round_button f_request', remote: true, data: { type: 'json', 'user-id': user.id }
		elsif user == @user
			link_to 'Send friend request', user_friendship_requests_path(user), method: 'post', id: 'f_request', class: 'round_button f_request', remote: true, data: { type: 'json', 'user-id': user.id }
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
			link_to 'Accept', user_friendships_path(user), method: 'post', class: 'round_button small'
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
			link_to 'Reject', friendship_request_path(received_request), method: 'delete', class: 'round_button small'
		end
	end

	def destroy_friendship_button(user)
		return unless current_user
		return unless current_user == @user
		return if user == current_user
		friendship = current_user.friendships.detect do |relation|
			relation.friend_id == user.id
		end
		if friendship
			link_to '(Unfriend)', friendship_path(friendship), class: 'unfriend', method: 'delete', remote: true,
			confirm: "Are you sure you want to unfriend #{user.name}?", data: { type: 'json', 'friendship-id': friendship.id }
		end
	end

	def profile_picture(user)
		if user.avatar.file.nil?
			return image_url('default_avatar.png')
		else
			return user.avatar.url
		end
	end

	def edit_profile(user)
		return unless current_user
		if user == current_user or is_admin
			link_to 'Edit profile', edit_user_path(user), class: 'round_button'
		end
	end

	def calendar_link(user)
		return unless current_user
		if user == current_user
			link_to 'Synchronise calendar', redirect_user_path(@user), class: 'round_button'
		end
	end

	def download_csv_button(user)
		return unless current_user
		if user == current_user
			link_to 'Download winnings history', user_path(user: user, format: :csv), class: 'round_button'
		end
	end

	def history_button(user)
		return unless current_user
			if user == current_user
				link_to 'Bet history', history_user_path(user: user), class: 'round_button'
		end
	end
end

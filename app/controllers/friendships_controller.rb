class FriendshipsController < ApplicationController
  include Secured
  before_action :set_friendship, only: [:destroy]
  before_action :logged_in?

  # GET /users/new
  def new
    @friendship = Friendship.new
  end

  # POST /users
  # POST /users.json
  def create
    user = User.find(params[:user_id])
    friendship = current_user.friendships.build(friend: user.id)
    if frienship.save
      reciprocal_friendship = user.friendships.build(friend: current_user.id)
      if reciprocal_friendship.save
        request_1 = FriendshipRequest.find_by(sender: current_user, recipient: user)
        request_2 = FriendshipRequest.find_by(sender: user, recipient: current_user)
        request_1.destroy if request_1
        request_2.destroy if request_2
        redirect_to root_path, notice: "Friendship request accepted!"
      else
        friendship.destroy
        redirect_to root_path, notice: "There was an error creating the friendship"
      end
    else
      redirect_to root_path, alert: 'Friend request could not be sent.'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    friendship = Friendship.find(params[:id])
    user = friendship.user
    friend = frienship.friend
    reciprocal_friendship = Friendship.find_by(user: friend, friend: user)
    frienship.destroy
    if reciprocal_friendship
      reciprocal_friendship.destroy
    end
    redirect_to root_path, notice: "Friendship ended."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end
end

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
    friendship = current_user.friendships.build(friend: user)
    if friendship.save
      reciprocal_friendship = user.friendships.build(friend: current_user)
      if reciprocal_friendship.save
        request_1 = FriendshipRequest.find_by(sender: current_user, recipient: user)
        request_2 = FriendshipRequest.find_by(sender: user, recipient: current_user)
        request_1.destroy if request_1
        request_2.destroy if request_2
        respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "You and #{user.name} are now friends!") }
        format.json do
          render json: {
            friendship: {
              name: current_user.name,
              id: current_user.id
            },
            message: "You and #{user.name} are now friends!"
          }
        end
      end
      else
        friendship.destroy
        redirect_back(fallback_location: root_path, notice: "There was an error creating the friendship")
      end
    else
      redirect_back(fallback_location: root_path, notice: "There was an error creating the friendship")
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    puts 'callin'
    friendship = Friendship.find(params[:id])
    user = friendship.user
    friend = friendship.friend
    reciprocal_friendship = Friendship.find_by(user: friend, friend: user)
    friendship.destroy
    reciprocal_friendship.destroy
    respond_to do |format|
      # format.html do
      #   { redirect_back(fallback_location: root_path, notice: "Friendship with #{friend.name} ended.") }
      format.json do
        render json: {
          status: 'deleted',
          notice: "Friendship with #{friend.name} ended."
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end
end

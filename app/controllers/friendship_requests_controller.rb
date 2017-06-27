class FriendshipRequestsController < ApplicationController
  include Secured
  before_action :set_friendship_request, only: [:destroy]
  before_action :logged_in?

  # GET /users/new
  def new
    @friendship_request = FriendshipRequest.new
  end

  # POST /users
  # POST /users.json
  def create
    user = User.find(params[:user_id])
    friend_request = user.incoming_requests.build(sender_id: current_user.id)
    if friend_request.save
      if friend_request.sender == current_user
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "Friend request sent to #{user.name}.") }
          format.json do
            render json: {
              request: {
                id: friend_request.id,
                name: friend_request.sender.name
              },
              message: "Friend request sent to #{user.name}."
            }
          end
        end
      else
        redirect_back(fallback_location: root_path, notice: "Friend request sent to #{user.name}.")
      end
    else
      redirect_back(fallback_location: root_path, alert: 'Friend request could not be sent.')
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    request = FriendshipRequest.find(params[:id])
    request.destroy
    if request.sender == current_user      
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Friend request to #{request.recipient.name} cancelled.") }
        format.json do
          render json: {
            unrequest: {
              id: request.recipient.id,
              name: request.sender.name
            },
            message: "Friend request to #{request.recipient.name} cancelled."
          }
        end
      end
    else
      redirect_back(fallback_location: root_path, notice: "Friend request from #{request.sender.name} rejected.")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship_request
      @friendship_request = FriendshipRequest.find(params[:id])
    end
end

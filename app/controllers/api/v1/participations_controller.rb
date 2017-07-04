module Api::V1
	class ParticipationsController < ApiController
		before_action :authenticate, only: [:create, :destroy]


		def create
		    @bet = Bet.find(params[:bet_id])
		    params[:user_id] = @current_user.id
		    @participation = @bet.participations.build(participation_params)
		    unless @participation.save
		    	render json: { errors: @participation.errors }, status: :unprocessable_entity
		    end
		end
		
		def destroy
			participation = Participation.find(params[:id])
			user = participation.user
			if @current_user == user or ['admin'].include?(@current_user.role)
				participation.destroy
				render json: { sucess: "Participation destroy" }, status: 200
			else
				render json: { errors: "current_user different to participation" }, status: :unprocessable_entity
			end
		end

		private
		
			def participation_params
		      params.permit(:amount,:user_id,:choice_id,:bet_id)
		    end
	end
end

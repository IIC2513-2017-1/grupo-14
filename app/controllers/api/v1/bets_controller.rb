module Api::V1
	class BetsController < ApiController
		before_action :authenticate, only: [:create, :destroy]


		def index
			@bets = Bet.all
		end

		def show
			@bet = Bet.find(params[:id])
		end

		def create
		    params[:user_id] = @current_user.id
		    @bet = Bet.new(bet_params)
		    unless @bet.save
		    	render json: { errors: @participation.errors }, status: :unprocessable_entity
		    end
		end
		def destroy
			@bets = Bet.all
			@bet = Bet.find(params[:id])
			if ['admin','mod'].include?(@current_user.role) or @current_user == @bet.user
			    @bet.participations.each do |part|
			      part.destroy
			    end
			    @bet.destroy
			else
				render json: { errors: 'Unauthorized access!' }, status: 401
			end
		end

		private


		def bet_params
	      params.permit(:name, :description, :deadline, :max_participants, :kind, :min_bet, :max_bet, :user_id,:private)
	    end
	end
end

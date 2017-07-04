module Api::V1
	class ChoicesController < ApiController
		before_action :authenticate, only: [:create, :destroy]


		def create
		    @bet = Bet.find(params[:bet_id])
			if ['admin','mod'].include?(@current_user.role) or @current_user == @bet.user
			    choice = Choice.new(choice_params)
			    unless choice.save
			    	render json: { errors: @participation.errors }, status: :unprocessable_entity
			    end
			else
				render json: { errors: 'Unauthorized access!' }, status: 401
			end
		end

		def destroy
			choice = Choice.find(params[:id])
			@bet = choice.bet
			if ['admin','mod'].include?(@current_user.role) or @current_user == @bet.user
				choice.destroy
			else
				render json: { errors: 'Unauthorized access!' }, status: 401
			end
		end


		private

		def choice_params
	      params.permit(:value,:bet_id)
	    end

	    def is_admin
	      if @current_user
	        ['admin','mod'].include?(@current_user.role)
	      end
	    end
	end
end
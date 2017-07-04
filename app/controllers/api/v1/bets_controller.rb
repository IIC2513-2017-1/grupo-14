module Api::V1
	class BetsController < ApiController
		def index
			@bets = Bet.all
		end

		def show
			@bet = Bet.find(params[:id])
		end
	end
end

module Api::V1
	class UsersController < ApiController
		before_action :authenticate, only: [:index, :show]

		def index
			@users = User.all
		end

		def show
			@user = User.find(params[:id])
		end

		def new
		end

		def create
			@user = User.new(user_params)
			@user.role = 'regular'
			@user.balance = 10000
			if @user.save
				@user.generate_token_and_save
			else
		        render json: { errors: @user.errors }, status: :unprocessable_entity
		    end

		end

		private

			def user_params
				params.permit(:name, :mail, :password, :password_confirmation).reject { |k, v| v.blank? }
			end
	end
end

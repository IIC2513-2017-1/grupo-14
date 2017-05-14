class SessionsController < ApplicationController
  def new
  end

   def create
    user = User.find_by(name: params[:session][:name])
    if user&.password == params[:session][:password]
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Login successful.'
    else
      redirect_to(new_session_path, alert: 'Wrong username or password.')
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Logout successful.'
  end
end

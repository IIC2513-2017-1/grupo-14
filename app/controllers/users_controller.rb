class UsersController < ApplicationController
  include Secured
  helper_method :is_not_regular
  helper_method :is_admin

  before_action :set_user, only: [:show, :sync_calendar, :edit, :update, :destroy]
  before_action :logged_in?, only: [:index, :show, :edit, :update, :destroy, :new_event]
  before_action :not_logged_in?, only: [:new, :create]
  before_action :is_current_user?, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.csv
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if not is_admin
      @user[:role] = 'regular'
    end

    @user.balance = 10000

    respond_to do |format|
      if @user.save
        @user.generate_token_and_save
        MailConfirmationMailer.new_user_email(@user).deliver_later
        format.html { redirect_to root_path, notice: 'Please check your email inbox for a confirmation mail.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sync_calendar

      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
      })

      client.update!(session[:authorization])

      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client

      @event_list = service.list_events('primary')


      @user.bets.each do |bet|
        is_repeated = false
        @event_list.items.each do |check|
          if check.summary == bet.name and check.start.date.to_date == bet.deadline.to_date
            is_repeated = true
          end
        end
        unless is_repeated
          event = Google::Apis::CalendarV3::Event.new({
            start: Google::Apis::CalendarV3::EventDateTime.new(date: bet.deadline),
            end: Google::Apis::CalendarV3::EventDateTime.new(date: bet.deadline + 1),
            summary: bet.name
          })
          service.insert_event('primary', event)
        end
      end

      @user.participations.each do |participation|
        is_repeated = false
        @event_list.items.each do |check|
          if check.summary == participation.bet.name and check.start.date.to_date == participation.bet.deadline.to_date
            is_repeated = true
          end
        end
        unless is_repeated
          event = Google::Apis::CalendarV3::Event.new({
            start: Google::Apis::CalendarV3::EventDateTime.new(date: participation.bet.deadline),
            end: Google::Apis::CalendarV3::EventDateTime.new(date: participation.bet.deadline + 1),
            summary: participation.bet.name
          })
          service.insert_event('primary', event)
        end
      end

      redirect_to(@user, notice: 'Calendar synced!')


  end

  def redirect
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_user_url
      })

      redirect_to client.authorization_uri.to_s
  end

  def callback
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        redirect_uri: callback_user_url,
        code: params[:code]
      })

      response = client.fetch_access_token!

      session[:authorization] = response

      redirect_to sync_calendar_user_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :mail, :password, :password_confirmation, :role, :avatar, :balance).reject { |k, v| v.blank? }
    end

    def is_current_user?
      redirect_to(root_path, alert: 'Unauthorized access!') unless @user == current_user or is_admin
    end

    def is_not_regular
      current_user.role != 'regular'
    end

    def is_admin
      if current_user
        current_user.role == 'admin'
      end
    end

end

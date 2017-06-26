class ParticipationsController < ApplicationController
  include Secured
  before_action :logged_in?, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_participation, only: [:show, :edit, :update, :destroy]
  # before_action :valid_date, only: [:new, :create, :edit, :upate, :destroy]

  # GET /participations
  # GET /participations.json
  def index
    @participations = Participation.all
  end

  # GET /participations/1
  # GET /participations/1.json
  def show
  end

  # GET /participations/new
  def new
    @bet = Bet.find(params[:bet_id])
    @participation = @bet.participations.build
  end

  # GET /participations/1/edit
  def edit
  end

  # POST /participations
  # POST /participations.json
  def create
    @bet = Bet.find(params[:bet_id])
    params[:participation][:user_id] = current_user.id
    @participation = @bet.participations.build(participation_params)

    respond_to do |format|
      if @participation.save
        user = @participation.user
        user.balance -= @participation.amount
        user.save
        format.html { redirect_to bets_url, notice: 'You are now participating in this bet.' }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participations/1
  # PATCH/PUT /participations/1.json
  def update
    respond_to do |format|
      if @participation.update(participation_params)
        format.html { redirect_back(fallback_location: @bet, notice: 'Participation was successfully updated.') }
        format.json { render :show, status: :ok, location: @participation }
      else
        format.html { render :edit }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @bet = @participation.bet
    user = @participation.user
    user.balance += @participation.amount
    user.save
    @participation.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: @bet, notice: 'You are no longer participating in this bet.') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participation
      @participation = Participation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participation_params
      params.require(:participation).permit(:amount,:user_id,:choice_id,:bet_id)
    end

    def valid_date
      bet_date = @participation.bet.deadline
      unless bet_date.future? or bet_date == Date.today
        redirect_to @participation.bet, alert: "Bet is no longer active"
        return
      end
    end
end

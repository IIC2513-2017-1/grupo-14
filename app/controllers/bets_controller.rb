class BetsController < ApplicationController
  include Secured
  before_action :logged_in?, only: %i[new create edit update destroy]
  before_action :set_bet, only: [:show, :edit, :update, :destroy]
  before_action :can_view?, only: [:show, :edit, :update, :destroy]
  before_action :is_owner?, only: [:edit, :update]

  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
  end

  # GET /bets/new
  def new
    @bet = Bet.new
    @bet.choices.build
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets
  # POST /bets.json
  def create
    params[:bet][:user_id] = current_user.id
    @bet = Bet.new(bet_params)

    respond_to do |format|
      if @bet.save
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render :show, status: :created, location: @bet }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { render :show, status: :ok, location: @bet }
      else
        format.html { render :edit }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.participations.each do |part|
      part.destroy
    end
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url, notice: 'Bet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    def is_owner?
      redirect_to @bet, alert: "Unauthorized access!" unless @bet.user == current_user or current_user.role != 'regular'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.require(:bet).permit(:name, :description, :deadline, :max_participants, :kind, :min_bet, :max_bet, :user_id,:private, :value, choices_attributes: [:value])
    end

    def can_view?
      if @bet.private
        redirect_to root_path, alert: "Unauthorized access!" unless current_user and (@bet.user == current_user or current_user.role != 'regular' or @bet.user.friends.include?(current_user))
      end
    end
end

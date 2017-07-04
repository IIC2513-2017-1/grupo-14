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
    respond_to do |format|
      format.html
      format.js
    end
  end

  def paginate
    pp = params[:pp].to_i()-1
    pl = params[:pl].to_i()
    first_bet = pp*pl
    last_bet = first_bet + pl - 1
    puts 'first'
    puts first_bet
    puts 'last'
    puts last_bet

    @bets = Bet.all

    if not current_user
      bet_list = @bets.active.not_private.sort_by {|bet| bet.deadline}[first_bet..last_bet]
    elsif current_user and current_user.role == 'regular'
      bet_list = @bets.bettable(current_user).sort_by {|bet| bet.deadline}[first_bet..last_bet]
    else
      bet_list = @bets.active.sort_by {|bet| bet.deadline}[first_bet..last_bet]
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: bets_path, notice: "Success") }
      format.json do
        render json: {
          bet_list: bet_list.pluck(:id),
          page: params[:pp]
        }
      end
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    bets = @user.participations.where()
  end

  def partial_bet_show
    bets = params[:bets]
    render(partial: "show", locals: {ids: bets})
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

  def bet_range(page_number, bets_per_page)
    if not current_user
      bet_list = @bets.active.not_private.sort_by {|bet| bet.deadline}[page_number-1..page_number*bets_per_page]
    elsif current_user and current_user.role == 'regular'
      bet_list = @bets.bettable(current_user).sort_by {|bet| bet.deadline}[page_number-1..page_number*bets_per_page]
    else
      bet_list = @bets.active.sort_by {|bet| bet.deadline}[page_number-1..page_number*bets_per_page]
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: bets_path, notice: "Success") }
      format.json do
        render json: {
          bet_list: bet_list
        }
      end
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
      params.require(:bet).permit(:name, :description, :deadline, :max_participants, :kind, :min_bet, :max_bet, :user_id, :private, :value, :p, :pl, choices_attributes: [:value])
    end

    def can_view?
      if @bet.private
        redirect_to root_path, alert: "Unauthorized access!" unless current_user and (@bet.user == current_user or current_user.role != 'regular' or @bet.user.friends.include?(current_user))
      end
    end
end

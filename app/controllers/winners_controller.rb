class WinnersController < ApplicationController
  include Secured
  
  before_action :logged_in?
  before_action :set_winner, only: [:destroy]

  
  # GET /participations/new
  def new
  	@bet = Bet.find(params[:bet_id])
    @winner = @bet.build_winner
  end

  # POST /participations
  # POST /participations.json
  def create
  	@bet = Bet.find(params[:bet_id])
    @winner = @bet.build_winner(winner_params)

    respond_to do |format|
      if @winner.save
        sumar_total
      	@bet.participations.each do |participation|
          ganado = participation.amount * (porcentaje + 1)
          participation.user.balance += ganado.round
          participation.user.save
      		MailConfirmationMailer.close_bet_email(participation,@bet,@winner).deliver_later
      	end
        format.html { redirect_to @bet, notice: 'Winner choice was successfully selected .' }
        format.json { render :show, status: :created, location: @winner }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @winner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @winner.destroy
    respond_to do |format|
      format.html { redirect_to winners_url, notice: 'Winner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_winner
      @winner = Winner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def winner_params
      params.require(:winner).permit(:bet_id,:choice_id)
    end

    def sumar_total
      total = 0
      not_amount = 0
      @bet.participations.each do |participation|
        total = total + participation.amount
        if participation.choice.value == @winner.choice.value
          not_amount = not_amount + participation.amount
        end
      end
      recaudado = total - not_amount
      porcentaje = recaudado/total

    end
end

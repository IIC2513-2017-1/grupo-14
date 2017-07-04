class MailConfirmationMailer < ApplicationMailer

	def new_user_email(user)
    	@user = user
    	@url  = 'http://ludopath.herokuapp.com'
    	mail subject: "Welcome to Ludopath #{user.name}", to: user.mail
    end

    def close_bet_email(participation,bet, winner)
    	@user = participation.user
        @choice = participation.choice.value
    	@bet = bet
    	@url  = 'http://ludopath.herokuapp.com'
    	@winner = winner.choice.value
    	mail subject: "Closed Bet #{bet.name}", to: participation.user.mail
    end
end

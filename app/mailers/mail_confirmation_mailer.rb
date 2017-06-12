class MailConfirmationMailer < ApplicationMailer

	def new_user_email(user)
    	@user = user
    	@url  = 'http://localhost:3000'
    	mail subject: "Welcome to Ludopath #{user.name}", to: user.mail
    end

    def close_bet_email(user,bet, winner)
    	@user = user
    	@bet = bet
    	@url  = 'http://localhost:3000'
    	@winner = winner
    	mail subject: "Closed Bet #{bet.name}", to: user.mail
    end
end

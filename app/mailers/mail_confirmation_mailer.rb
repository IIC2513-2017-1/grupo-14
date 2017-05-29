class MailConfirmationMailer < ApplicationMailer

	def new_user_email(user)
    	@user = user
    	@url  = 'http://localhost:3000'
    	mail subject: "Welcome to Ludopath #{user.name}", to: user.mail
   end
end
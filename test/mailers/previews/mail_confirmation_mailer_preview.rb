# Preview all emails at http://localhost:3000/rails/mailers/mail_confirmation_mailer
class MailConfirmationMailerPreview < ActionMailer::Preview
	def sample_mail_preview
	    MailConfirmationMailer.new_user_email(User.last)
	  end
end

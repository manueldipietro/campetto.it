class UserMailer < ApplicationMailer
    default from: 'campetto.it@gmail.com'
  
    def registration_confirmation(user)
      @user = user
      @url = confirm_user_url(user.confirmation_token)
      mail(to: @user.email, subject: 'Conferma la tua registrazione')
    end
  end
  

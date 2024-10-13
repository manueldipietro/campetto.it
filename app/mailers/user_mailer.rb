class UserMailer < ApplicationMailer
    default from: 'campetto.it@gmail.com'
  
    def registration_confirmation(user)
      @user = user
      @url = confirm_user_url(user.confirmation_token)
      mail(to: @user.email, subject: 'Conferma la tua registrazione')
    end

    def password_reset
      @user = params[:user]
      @reset_link = edit_password_url(token: params[:token], host: 'localhost:3000')
      mail(to: @user.email, subject: 'Reset della tua password')
    end
  end
  

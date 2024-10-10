class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
        user_params = params.require(:user).permit(:email, :password)

        @user = User.new(user_params)

        if @user.save
          UserMailer.registration_confirmation(@user).deliver_now
          flash[:notice] = "Registraione avvenuta con successo, ora conferma via email"
          redirect_to logReg_path(form: 'login')
        else
            flash[:alert] = "Email già registrata, usane un'altra."
            redirect_to logReg_path(form: 'signup')
        end
  end

  def accountUtente
    @user = User.find(session[:user_id])
    Rails.logger.debug("Current User in account: #{@user.inspect}")
  end
  
  def confirm
    user = User.find_by(confirmation_token: params[:token])

    if user.present? && !user.confirmed?
      user.confirm!
      flash[:notice] = 'Il tuo account è stato confermato. Ora puoi effettuare il login.'
      redirect_to logReg_path(form: 'login')
    else
      redirect_to root_path, alert: 'Token di conferma non valido.'
    end
  end

  private

  def require_login
    unless current_user
      redirect_to login_path, alert: 'Devi essere loggato per accedere a questa pagina.'
    end
  end
end



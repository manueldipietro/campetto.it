class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:new, :create, :confirm,:request_password_reset, :edit_password, :update_password]

  def new
    @user = User.new
  end
  
  def create
        @user = User.new(user_params)
        @user.confirmation_sent_at = Time.now

        if @user.save
          UserMailer.registration_confirmation(@user).deliver_now
          flash[:notice] = "Registrazione avvenuta con successo, ora conferma via email"
          redirect_to logReg_path(form: 'login')
        else
            flash[:alert] = "Email già registrata, usane un'altra."
            redirect_to logReg_path(form: 'signup')
        end
  end

  def accountUtente
    @user = current_user
  end
  
  #Conferma email
  def confirm
    user = User.find_by(confirmation_token: params[:token])
  
    if user.present? && !user.confirmed? && user.confirmation_sent_at >= 1.hours.ago
      user.update(confirmed_at: Time.now, confirmation_token: nil) 
      flash[:notice] = 'Il tuo account è stato confermato. Ora puoi effettuare il login.'
      redirect_to logReg_path(form: 'login')
    else
      flash[:alert] = 'Token di conferma non valido o scaduto. Registrati nuovamente.'
      redirect_to logReg_path(form: 'signup')
    end
  end
  

  #Modifica Password da accountUtente
  def modify_password
    user = User.find(current_user.id)

    if user.authenticate(params[:password_login])

        user.password = params[:password]  
        if user.save
          flash[:notice] = "Password cambiata con successo!"
          flash[:show_popup] = true
        else
          flash[:alert] = "Errore durante il salvataggio della nuova password."
          flash[:show_popup] = true
        end
    else
      flash[:alert] = "La password corrente è errata."
      flash[:show_popup] = true
    end

    redirect_to request.referrer
  end

  #Reset Password con email di recupero 
  def request_password_reset
    user = User.find_by(email: params[:email_reset])

    if user
      token = SecureRandom.urlsafe_base64
      user.update(reset_password_token: token, reset_password_sent_at: Time.now)

      UserMailer.with(user: user, token: token).password_reset.deliver_now
      flash[:success] = "Ti abbiamo inviato un'email per il reset della password."
    else
      flash[:error] = "Nessun utente trovato con questa email."
    end

    redirect_to root_path
  end

  def edit_password
    @user = User.find_by(reset_password_token: params[:token])

    if @user.nil? || @user.reset_password_sent_at < 2.hours.ago
      flash[:error] = "Il link è scaduto o non valido."
      redirect_to root_path
    end
  end

  def update_password
    @user = User.find_by(reset_password_token: params[:token])

    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      @user.update(reset_password_token: nil, reset_password_sent_at: nil)
      flash[:success] = "Password cambiata con successo! Ora puoi effetuare il login"
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit_password
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def require_logins
    unless current_user
      redirect_to login_path, alert: 'Devi essere loggato per accedere a questa pagina.'
    end
  end
end



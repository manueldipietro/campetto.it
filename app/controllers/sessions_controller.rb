class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: session_params[:email_login])
  
    if user&.authenticate(session_params[:password_login])
      session[:user_id] = user.id
      redirect_to welcome_path, notice: "Login avvenuto con successo!"
    else
      flash[:alert] = "Email o password errati."
      redirect_to logReg_path(form: 'login')
    end
  end  

  def welcome
    @user = User.find(session[:user_id])
  end

  def destroy
    session[:user_id] = nil 
    redirect_to root_path, notice: "Logout avvenuto con successo!"
  end

  def omniauth
    @user = User.find_or_create_by(uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider']) do |u|
        u.email = request.env['omniauth.auth']['info']['email']
        u.password = SecureRandom.hex(10)
    end
    if @user.valid?
        session[:user_id] = @user.id
        redirect_to welcome_path
    else
        render :new
    end
  end

  private
  def session_params
    params.require(:session).permit(:email_login, :password_login)
  end
end


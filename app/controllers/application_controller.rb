class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
  
    protect_from_forgery with: :exception

    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      !!current_user
    end

    def authenticate_user!
      unless logged_in?
          redirect_to logReg_path, alert: "Devi accedere per visualizzare questa pagina."
      end
    end
end
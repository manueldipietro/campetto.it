class ApplicationController < ActionController::Base
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    protect_from_forgery with: :exception
end
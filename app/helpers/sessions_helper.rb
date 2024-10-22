module SessionsHelper

    def log_in_administrator(administrator)
        session[:administrator_id] = administrator.id
    end

    def current_administrator
        @current_administrator ||= Administrator.find_by(id: session[:user_id])
    end

    def logged_in_administrator?
        !current_administrator.nil?
    end

end

module SessionsHelper

    # Logs in the given administrator
    def log_in_administrator(administrator)
        session[:administrator_id] = administrator.id
    end

    # Remembers an administrator in a persistent session
    def remember_administrator(administrator)
        administrator.remember
        cookies.permanent.signed[:administrator_id] = administrator.id
        cookies.permanent[:administrator_remember_token] = administrator.remember_token
    end

    # Returns true if the given administrator is the current admnistrator
    def current_administrator?(administrator)
        administrator == current_administrator
    end

    # Returns the current logged-in administrator (if any)
    def current_administrator
        if (administrator_id = session[:administrator_id])
            @current_administrator ||= Administrator.find_by(id: administrator_id)
        elsif (administrator_id = cookies.signed[:administrator_id])
            administrator = Administrator.find_by(id: administrator_id)
            if administrator && administrator.authenticated?(cookies[:administrator_remember_token])
                log_in_administrator administrator
                @current_administrator = administrator
            end
        end
    end
     
    # Returns true if the user is logged in, false otherwise
    def logged_in_administrator?
        !current_administrator.nil?
    end

    # Forgets a persistent session
    def forget_administrator(administrator)
        administrator.forget
        cookies.delete(:administrator_id)
        cookies.delete(:administrator_remember_token)
    end

    # Logs out the current administrator
    def log_out_administrator
        forget_administrator(current_administrator)
        session.delete(:administrator_id)
        @current_administrator = nil
    end

    # Redirects to stored location (or to the default)
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    # Stores the URL trying to be accessed
    def store_location
        session[:forwarding_url] = request.url if request.get?
    end

end

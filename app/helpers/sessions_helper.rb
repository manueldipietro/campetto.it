module SessionsHelper

    def log_in_administrator(administrator)
        session[:administrator_id] = administrator.id
    end

    def current_administrator
        if (administrator_id = session[:administrator_id])
            @current_administrator ||= Administrator.find_by(id: session[:administrator_id])
        elsif (administrator_id =cookies.signed[:administrator_id])
            administrator = Administrator.find_by(id: administrator_id)
            if administrator && administrator.authenticated?(cookies[:administrator_remember_token])
                log_in_administrator administrator
                @current_administrator = administrator
            end
        end
    end
            
    def logged_in_administrator?
        !current_administrator.nil?
    end

    def remember_administrator(administrator)
        administrator.remember
        cookies.permanent.signed[:administrator_id] = administrator.id
        cookies.permanent[:administrator_remember_token] = administrator.remember_token
    end

    def forget_administrator(administrator)
        administrator.forget
        cookies.delete(:administrator_id)
        cookies.delete(:administrator_remember_token)
    end

    def log_out_administrator
        forget(current_administrator)
        session.delete(:administrator_id)
        @current_administrator = nil
    end
end

class PartnerActivationsController < ApplicationController

    def edit
        user = User.find_by(email: params[:email])
        if partner && !partner.activated? && partner.authenticated?(:activation, params[:id])
            partner.activate
            log_in_partner partner
            flash[:success] = "Account attivato!"
            redirect_to partner_dashboard
        else
            flash[:danger] = "Invalid activation link"
            redirect_to root_url
        end
    end
    
end

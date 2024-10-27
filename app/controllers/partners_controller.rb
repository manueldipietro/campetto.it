class PartnersController < ApplicationController
  layout 'dashboard', only: [:dashboard]
  before_action :logged_in_partner, only: [:dashboard]

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      log_in @partner
      flash[:success] = "Benvenuto in Campetto.it!" #Per usare il flash va aggiunto al layout
      redirect_to partner_dashboard_path
    else
        render 'new'
    end
  end

  def dashboard
    @partner = Partner.find(session[:partner_id])
  end

  #myprofile e edit  
  
  #index for administrator
  def index
    
  end

  #index for 



  private
    
    def partner_params
      params.require(:partner).permit(:name, :surname, :gender, :mobile, :birthdate, :email, :password, :password_confimartion)
    end

    def logged_in_partner
      unless logged_in_partner?
        store_location
        flash[:danger] = "Non sei autorizzato ad accedere a questa pagina"
        redirect_to partner_log_in_url
      end
    end
end

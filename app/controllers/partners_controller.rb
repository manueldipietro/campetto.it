class PartnersController < ApplicationController
  layout 'dashboard', only: [:dashboard]
  before_action :logged_in_partner, only: [:dashboard]

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      @partner.send_activation_email
      flash[:info] = "Controlla la tua email per attivare il tuo account."
      redirect_to root_url
      #log_in @partner
      #flash[:success] = "Benvenuto in Campetto.it!" #Per usare il flash va aggiunto al layout
      #redirect_to partner_dashboard_path
    else
        #Cambia con redirect
        redirect_to administrator_log_in_path
        return
        render 'new'
    end
  end

  def dashboard
    @partner = Partner.find(session[:partner_id])
    @fields = Field.joins(:sports_center).where(sports_centers: { owner_id: @partner.id })
    @bookings = Booking.joins(slot: { field: :sports_center })
                   .where(sports_centers: { owner_id: @partner.id })
    
  end

  #myprofile e edit  
  
  #index for partner
  def index
  end
  
  private
    
    def partner_params
      params.require(:partner).permit(:name, :surname, :gender, :mobile, :birthdate, :email, :password, :password_confirmation)
    end

    def logged_in_partner
      unless logged_in_partner?
        store_location
        flash[:danger] = "Non sei autorizzato ad accedere a questa pagina"
        redirect_to partner_log_in_url
      end
    end
end

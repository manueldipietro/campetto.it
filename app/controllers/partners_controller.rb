class PartnersController < ApplicationController
  
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
  end


  private
    
    def partner_params
      params.require(:partner).permit(:name, :surname, :gender, :mobile, :birthdate, :email, :password, :password_confimartion)
    end

end

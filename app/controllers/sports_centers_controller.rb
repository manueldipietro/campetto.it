class SportsCentersController < ApplicationController
    before_action :logged_in_partner, only: [:new, :create, :index]
    #before_action :logged_in_administrator,

    # Partner method
    def new
        @sports_center = SportsCenter.new
    end
    
    def create
        @sports_center = SportsCenter.new(sports_center_params)
        @sports_center.owner_id  = current_partner_id
        if @sports_center.save
            render json: { message: "Created!"}, status: :created
        else
            puts @sports_center.errors.full_messages
            render json: { message: "Error!" }, status: :unprocessable_entity
        end
    end

    # Send JSON with all accessible sports center from the partner
    def index
        partner_id = current_partner_id
        owned_centers = SportsCenter.where(owner_id: partner_id)
        managed_centers = SportsCenter.joins(:managers).where(partners_sports_centers: {partner_id: partner_id})
        accessible_centers = (owned_centers + managed_centers).uniq
        render json: accessible_centers, status: :ok
    end

    def edit
        @sports_center = SportsCenter.find(params[:id]);
        render partial: 'edit', layout: false
    end

    def update
        Rails.logger.debug(params.inspect)
        @sports_center = SportsCenter.find(params[:sports_center][:id]);
        if @sports_center.update(sports_center_params)
            render json: {}, status: :ok;
        else
            render json: {}, status: :unprocessable_entity
        end
    end

    def destroy
        sports_center = SportsCenter.find(params[:id])
        if sports_center
            sports_center.destroy
        end
        redirect_to partner_dashboard_path
    end

    # Delegated management
    def create_delegate
        #Renderizza il form per creare un delegato
    end

    def index_delegate
        #Mostra tutti i delegate di un campo sportivo
    end

    def remove_delegate
        #Rimuove un delegate da un campo sportivo

    end

    # Funzioni per amministratore
    
    private
        def sports_center_params
            params.require(:sports_center).permit(:tax_code, :vat_number, :iban, :email, :phone, :company_name, :registered_office)
        end

        def sports_center_update_params
            params.require(:sports_center).permit(:iban, :email, :phone, :registered_office);
        end
        
        def logged_in_partner
            unless logged_in_partner?
              store_location
              flash[:danger] = "Non sei autorizzato ad accedere a questa pagina"
              redirect_to partner_log_in_url
            end
        end

        def current_partner_id
            current_partner.id
        end
      
end

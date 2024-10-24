class AdministratorsController < ApplicationController
  layout 'dashboard', only: [:dashboard]
  before_action :logged_in_administrator,   only: [:edit, :update, :dashboard] #,:delete

  #This method show the administrator page, TODO: make accessible only from owner and from other administrator with root privileges
  def show
    @administrator = Administrator.find(params[:id])
  end
  
  #This method show the signup form, TODO: make this accessible on dashboard only from root administrator
  def new
    @administrator = Administrator.new
  end

  #This metod is intended to be used with AJAX
  def create
    @administrator = Administrator.new(administrator_params)
    if @administrator.save
      #flash[:success]
      #log_in @administrator
      redirect_to administrator_log_in_path
    else
      render json: { message: 'Error during administrator creation. Invalid params' }, status: :unprocessable_entity
    end
  end

  def myprofile
    @administrator = Administrator.find(session[:administrator_id])
  end

  def update
    @administrator = Administrator.find(session[:administrator_id])
    if @administrator.update_attributes(administrator_update_params)
      flash[:success] = "Dati aggiornati con successo"
      redirect_to edit
      return
    else
      render 'edit'
    end
  end

  def dashboard
    @administrator = Administrator.find(session[:administrator_id])
    @reports = Report.all
  end
  
  private
    def administrator_params
      params.require(:administrator).permit(:name, :surname, :email, :password, :password_confimartion, :root)
    end

    def administrator_update_params
      params.require(:administrator).permit(:password, :password_confimartion)
    end

    # Confirms a logged-in administrator
    def logged_in_administrator
      unless logged_in_administrator?
        store_location
        flash[:danger] = 'Non sei autorizzato ad accedere a questa pagina, autenticati!'
        redirect_to administrator_log_in_url
      end
    end
    
    # Confirms a root administrator
    def root_administrator
      redirect_to(administrator_dashboard_url) unless current_user.admin?
    end

end

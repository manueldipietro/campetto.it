class AdministratorsController < ApplicationController
  
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
      render json: { message: 'New administrator created sucessfully' }, status: :created
      #flash[:success]
      #log_in @administrator
    else
      render json: { message: 'Error during administrator creation. Invalid params' }, status: :unprocessable_entity
    end
  end

  def dashboard
  end
  
  private
    def administrator_params
      params.require(:administrator).permit(:name, :surname, :email, :password, :password_confimartion)
    end

end

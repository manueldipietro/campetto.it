class AdministratorsController < ApplicationController
  
  def show
    @administrator = Administrator.find(params[:id])
  end
  
  def new
    
  end
end

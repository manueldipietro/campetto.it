class FieldsController < ApplicationController
  # Rimuoviamo per ora l'autenticazione
  before_action :set_field, only: [:show, :edit, :update, :destroy]

  # Lista di tutti i campi
  def index
    @fields = Field.all
  end

  # Form per creare un nuovo campo
  def new
    @field = Field.new
  end

  def create
    address = params[:field][:indirizzo]
    results = Geocoder.search(address)

    if results.any?
      coordinates = results.first.coordinates
      params[:field][:latitudine] = coordinates[0]
      params[:field][:longitudine] = coordinates[1]
    else
      flash[:alert] = "Coordinate non trovate. Assicurati che l'indirizzo sia corretto."
      @field = Field.new(field_params)
      render :new and return
    end

    @field = Field.new(field_params)

    if @field.save
      redirect_to @field, notice: 'Campo creato con successo.'
    else
      render :new
    end
  end

  # Form per modificare un campo esistente
  def edit
  end

  # Aggiorna un campo esistente
  def update
    if @field.update(field_params)
      redirect_to @field, notice: "Campo sportivo aggiornato con successo."
    else
      render :edit
    end
  end

  # Elimina un campo
  def destroy
    @field.destroy
    redirect_to fields_path, notice: "Campo sportivo eliminato con successo."
  end

  def search
    indirizzo = params[:indirizzo]
    sport = params[:sport]
    data = params[:data] 

    if indirizzo.present?
      results = Geocoder.search(indirizzo)
      
      if results.any?
        coordinates = results.first.coordinates 
        lat = coordinates[0]
        lon = coordinates[1]
  
        @fields = Field.near([lat, lon], 20) 

        @fields = @fields.where(sport: sport) unless sport == "Tutti"
        
      else
        flash[:alert] = "Indirizzo non valido. Per favore riprova."
        @fields = Field.none
      end
    else
      @fields = Field.none
    end
    @selected_date = data.present? ? Date.parse(data) : Date.today
    render 'search'
  end
  

  def show
    @field = Field.find(params[:id])

    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today

    if @selected_date < Date.today
      @selected_date = Date.today
    end

    @slots = @field.slots.where('DATE(start_time) = ?', @selected_date)
                         .where(booked: false)
                         .order(:start_time)
  end

  def reverse_geocode
    lat = params[:lat].to_f
    lon = params[:lon].to_f
    results = Geocoder.search([lat, lon])

    if results.any?
      render json: { address: results.first.address }
    else
      render json: { error: 'Indirizzo non trovato' }, status: 404
    end
  end

  private

  # Trova il campo in base all'id
  def set_field
    @field = Field.find(params[:id])
  end

  # Parametri permessi
  def field_params
    params.require(:field).permit(:nome, :descrizione, :sport, :prezzo, :indirizzo, :image, :start_time, :end_time, :interval, exclude_days: [])
  end
end


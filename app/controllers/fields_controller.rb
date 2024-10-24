class FieldsController < ApplicationController
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

  # Funzione di ricerca dei campi
  def search
    indirizzo = params[:indirizzo]
    sport = params[:sport]
    data = params[:data]
    raggio = params[:raggio].to_i
    citta = params[:citta]

    # Se né la città né l'indirizzo sono presenti, mostra un avviso e mantieni i parametri nel form
    if citta.blank? && indirizzo.blank?
      flash[:alert] = "Inserisci un indirizzo o una città per effettuare la ricerca."
      @fields = Field.none
      # Mantieni i parametri per ripopolare il form
      @selected_indirizzo = indirizzo
      @selected_citta = citta
      @selected_raggio = raggio
      @selected_sport = sport
      @selected_date = data
      render 'search' and return
    end

    # Se è presente la città, ignora il raggio e l'indirizzo
    if citta.present?
      city_results = Geocoder.search(citta)
      if city_results.any?
        city_coordinates = city_results.first.coordinates
        lat = city_coordinates[0]
        lon = city_coordinates[1]
        # Trova tutti i campi nella città, ignorando il raggio
        @fields = Field.near([lat, lon], 50)
      else
        flash[:alert] = "Città non trovata. Per favore riprova."
        @fields = Field.none
        @selected_citta = citta
        @selected_raggio = raggio
        @selected_sport = sport
        @selected_date = data
        render 'search' and return
      end
    elsif indirizzo.present?
      # Ricerca basata sull'indirizzo e applica il raggio
      results = Geocoder.search(indirizzo)
      if results.any?
        coordinates = results.first.coordinates
        lat = coordinates[0]
        lon = coordinates[1]
        # Cerca i campi vicino all'indirizzo specificato
        @fields = Field.near([lat, lon], raggio)
      else
        flash[:alert] = "Indirizzo non valido. Per favore riprova."
        @fields = Field.none
        @selected_indirizzo = indirizzo
        @selected_raggio = raggio
        @selected_sport = sport
        @selected_date = data
        render 'search' and return
      end
    end

    # Filtro per sport se selezionato
    @fields = @fields.where(sport: sport) unless sport == "Tutti"
    @selected_date = data.present? ? Date.parse(data) : Date.today

    # Mantieni i parametri per mostrarli nuovamente nei campi del form
    @selected_indirizzo = indirizzo
    @selected_citta = citta
    @selected_raggio = raggio
    @selected_sport = sport
    @selected_date = data

    render 'search'
  end

 def show
  @field = Field.find(params[:id])
  
  # Controlla se il parametro :date è presente e valido, altrimenti usa la data odierna
  begin
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
  rescue ArgumentError
    # In caso di formato data non valido, imposta la data odierna
    flash[:alert] = "Data non valida, impostata la data odierna."
    @selected_date = Date.today
  end

  if @selected_date < Date.today
    @selected_date = Date.today
  end

  # Carica gli slot disponibili per la data selezionata
  @slots = @field.slots.where('DATE(start_time) = ?', @selected_date)
                       .where(booked: false)
                       .order(:start_time)
end

  # Funzione per il reverse geocoding
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


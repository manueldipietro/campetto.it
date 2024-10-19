class FieldsController < ApplicationController
  # Rimuoviamo per ora l'autenticazione
  before_action :set_field, only: [:show, :edit, :update, :destroy]

  # Lista di tutti i campi
  def index
    @fields = Field.all
  end

  # Mostra un singolo campo
  def show
  end

  # Form per creare un nuovo campo
  def new
    @field = Field.new
  end

  # Crea un nuovo campo
  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to @field, notice: "Campo sportivo creato con successo."
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

  #s Elimina un campo
  def destroy
    @field.destroy
    redirect_to fields_path, notice: "Campo sportivo eliminato con successo."
  end

  def search
    @fields = Field.all

    # Filtra per nome del campo, se presente
    if params[:indirizzo].present?
      @fields = @fields.where("nome ILIKE ?", "%#{params[:indirizzo]}%")
    end

    # Filtra per sport solo se è selezionato uno sport diverso da 'Tutti'
    if params[:sport].present? && params[:sport] != 'Tutti'
      @fields = @fields.where(sport: params[:sport])
    end

    # Renderizza la view per visualizzare i risultati
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

  private

  # Trova il campo in base all'id
  def set_field
    @field = Field.find(params[:id])
  end

  # Parametri permessi
  def field_params
    params.require(:field).permit(:nome, :descrizione, :sport, :prezzo, :latitudine, :longitudine, :image, :start_time, :end_time, :interval, exclude_days: [])
  end
end


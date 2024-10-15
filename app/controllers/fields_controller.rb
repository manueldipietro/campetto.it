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

  # Elimina un campo
  def destroy
    @field.destroy
    redirect_to fields_path, notice: "Campo sportivo eliminato con successo."
  end

  def search
    @fields = Field.where(sport: params[:sport])
  end
  
  private

  # Trova il campo in base all'id
  def set_field
    @field = Field.find(params[:id])
  end

  # Parametri permessi
  def field_params
    params.require(:field).permit(:nome, :descrizione, :sport, :prezzo, :latitudine, :longitudine, :image)
  end
end


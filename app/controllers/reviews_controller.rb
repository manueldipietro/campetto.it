class ReviewsController < ApplicationController
  before_action :set_field
  before_action :set_review, only: [:edit, :update, :destroy]

  # Visualizza tutte le recensioni di un campo sportivo
  def index
    @reviews = @field.reviews
  end

  # Form per creare una nuova recensione
  def new
    @review = @field.reviews.build
  end

  # Crea una nuova recensione
  def create
    @review = @field.reviews.build(review_params)
    @review.user = current_user  # L'utente autenticato lascia la recensione

    if @review.save
      redirect_to field_reviews_path(@field), notice: "Recensione creata con successo."
    else
      render :new
    end
  end

  # Modifica una recensione
  def edit
  end

  # Aggiorna una recensione
  def update
    if @review.update(review_params)
      redirect_to field_reviews_path(@field), notice: "Recensione aggiornata con successo."
    else
      render :edit
    end
  end

  # Elimina una recensione
  def destroy
    @review.destroy
    redirect_to field_reviews_path(@field), notice: "Recensione eliminata con successo."
  end

  private

  def set_field
    @field = Field.find(params[:field_id])
  end

  def set_review
    @review = @field.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:titolo, :valutazione, :testo)
  end
end


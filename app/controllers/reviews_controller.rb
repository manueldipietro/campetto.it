class ReviewsController < ApplicationController
  before_action :set_field, only: [:index, :new, :create, :destroy]
  before_action :require_user
  before_action :set_review, only: [:destroy]
  before_action :authorize_user, only: [:destroy]

  # Visualizza tutte le recensioni per un campo specifico
  def index
    @reviews = @field.reviews.order(created_at: :desc)
  end

  # Visualizza tutte le recensioni dell'utente corrente
  def user_index
    @reviews = Review.where(user: current_user).includes(:field).order(created_at: :desc)
  end

  def new
    @review = @field.reviews.build
  end

  def create
    @review = @field.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      flash[:success] = "Recensione aggiunta con successo."
      redirect_to field_reviews_path(@field)
    else
      render 'new'
    end
  end

  def destroy
    @review.destroy
    flash[:success] = "Recensione eliminata con successo."
    redirect_to field_reviews_path(@field)
  end

  private

  def set_field
    @field = Field.find(params[:field_id]) if params[:field_id]
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user
    redirect_to root_path, alert: "Non sei autorizzato a eliminare questa recensione." unless @review.user == current_user
  end

  def review_params
    params.require(:review).permit(:titolo, :valutazione, :testo)
  end

  def require_user
    redirect_to login_path, alert: "Devi essere loggato per eseguire questa azione." unless current_user
  end
end


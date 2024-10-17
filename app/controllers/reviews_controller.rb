class ReviewsController < ApplicationController
  before_action :set_field
  before_action :require_user, only: [:new, :create, :destroy]
  before_action :set_review, only: [:destroy]
  before_action :authorize_user, only: [:destroy]

  def index
    @reviews = @field.reviews.order(created_at: :desc)
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
    @field = Field.find(params[:field_id])
  end

  def set_review
    @review = @field.reviews.find(params[:id])
  end

  def authorize_user
    unless @review.user == current_user
      flash[:alert] = "Non sei autorizzato a eliminare questa recensione."
      redirect_to field_reviews_path(@field)
    end
  end

  def review_params
    params.require(:review).permit(:titolo, :valutazione, :testo)
  end

  def require_user
    unless current_user
      flash[:alert] = "Devi essere loggato per eseguire questa azione."
      redirect_to login_path
    end
  end
end


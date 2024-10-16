class ReviewsController < ApplicationController
  before_action :set_field
  before_action :require_user, only: [:new, :create]

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

  private

  def set_field
    @field = Field.find(params[:field_id])
  end

 def review_params
  params.require(:review).permit(:titolo, :valutazione, :testo)
end


  def require_user
    unless current_user
      flash[:alert] = "Devi essere loggato per aggiungere una recensione."
      redirect_to login_path
    end
  end
end


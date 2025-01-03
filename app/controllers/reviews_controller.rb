# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_field, only: [:field_reviews, :new, :create]
  before_action :require_user, except: [:field_reviews, :index, :show, :partner_reviews]
  before_action :set_review, only: [:destroy]
  before_action :authorize_user, only: [:destroy]
  before_action :admin_only, only: [:destroy]
  before_action :authenticate_partner!, only: [:partner_reviews]

  # Recensioni per i campi del partner
  def partner_reviews
    # Trova il partner con l'ID specificato
    @partner = Partner.find(params[:partner_id])

    # Prende gli ID dei centri sportivi del partner e filtra le recensioni
    sports_center_ids = @partner.owned_sports_centers.pluck(:id)
    @reviews = Review.joins(:field).where(fields: { sports_center_id: sports_center_ids }).order(created_at: :desc)

    # Aggiungi un messaggio se non ci sono recensioni
    flash.now[:info] = "Non ci sono recensioni disponibili per i tuoi campi sportivi." if @reviews.empty?

    respond_to do |format|
      format.html { render partial: 'partners/reviews' }
      format.json { render json: @reviews }
    end
  end

  # Visualizza tutte le recensioni per un campo specifico
  def field_reviews
    @field = Field.find(params[:field_id])
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
    if @review.destroy
      redirect_back(fallback_location: admin_dashboard_path, notice: 'Recensione eliminata con successo.')
    else
      redirect_back(fallback_location: admin_dashboard_path, alert: 'Impossibile eliminare la recensione.')
    end
  end

  private

  def set_field
    @field = Field.find(params[:field_id]) if params[:field_id]
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user
    unless current_user.admin? || @review.user == current_user
      redirect_to root_path, alert: "Non sei autorizzato a eliminare questa recensione."
    end
  end

  def review_params
    params.require(:review).permit(:titolo, :valutazione, :testo)
  end

  def require_user
    redirect_to login_path, alert: "Devi essere loggato per eseguire questa azione." unless current_user
  end

  def admin_only
    redirect_to root_path, alert: "Accesso non autorizzato." unless current_user.admin?
  end
end


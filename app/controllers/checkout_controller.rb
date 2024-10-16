class CheckoutController < ApplicationController
  # Assicurati che solo utenti autenticati possano prenotare
  before_action :require_user

  def create
    @field = Field.find(params[:field_id])

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur', # Aggiorna la valuta se necessario
          product_data: {
            name: "Prenotazione campo: #{@field.nome}",
          },
          unit_amount: (@field.prezzo * 100).to_i, # Converti l'importo in centesimi
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: checkout_success_url(field_id: @field.id),
      cancel_url: checkout_cancel_url(field_id: @field.id),
    )
    redirect_to session.url, allow_other_host: true
  end

  def success
    @field = Field.find(params[:field_id])
    # Qui puoi aggiungere logica per salvare la prenotazione nel database
    render 'success'
  end

  def cancel
    @field = Field.find(params[:field_id])
    render 'cancel'
  end

  private

  def require_user
    unless current_user
      flash[:alert] = "Devi essere loggato per prenotare un campo."
      redirect_to login_path
    end
  end
end


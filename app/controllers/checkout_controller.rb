class CheckoutController < ApplicationController 
def new 
end 
def create 
session = Stripe::Checkout::Session.create( 
payment_method_types: ['card'], 
line_items: [{ 
price_data: { 
currency: 'usd', 
product_data: { 
name: 'Prenotazione campo sportivo', 
}, 
unit_amount: 5000, 
}, 
quantity: 1, 
}], 
mode: 'payment', 
success_url: checkout_success_url,  # Reindirizza in caso di successo 
cancel_url: checkout_cancel_url,    # Reindirizza in caso di annullamento 
) 
redirect_to session.url, allow_other_host: true 
end 
def success 
render plain: "Il pagamento è stato completato con successo" 
end 
def cancel 
render plain: "Il pagamento è stato annullato." 
end 
end

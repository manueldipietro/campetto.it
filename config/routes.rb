Rails.application.routes.draw do
  root 'pages#home'
  
  get 'logReg', to: 'pages#logReg', as: 'logReg'

  # Rotte per il login
  get 'login', to: 'sessions#new' 
  post 'login', to: 'sessions#create' 
  delete 'logout', to: 'sessions#destroy'

  # Rotte per la registrazione
  get 'signup', to: 'users#new' 
  post 'signup', to: 'users#create' 

  # Omniauth
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  
  # Conferma email
  get 'confirm_email', to: 'users#confirm_email'

  # Porta l'utente al suo account
  get 'accountUtente', to: 'users#accountUtente'

  # Checkout routes
  get 'checkout/new', to:'checkout#new', as:'new_checkout'
  post 'checkout/create', to: 'checkout#create'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'

  # Ricerca campi
  get 'search_fields', to: 'fields#search', as: 'search_fields'

  # Risorse per utenti e sessioni
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  
  # Risorse per i campi e recensioni (recensioni nidificate)
  resources :fields do
    resources :reviews, except: [:show]
  end

  # Conferma email con token
  get 'confirm/:token', to: 'users#confirm', as: 'confirm_user'

  # Modifica password
  post 'modify_password', to: 'users#modify_password'

  # Rotte per recupero password
  post 'request_password_reset', to: 'users#request_password_reset'
  get 'edit_password', to: 'users#edit_password', as: 'edit_password'
  patch 'update_password', to: 'users#update_password'
end


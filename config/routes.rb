Rails.application.routes.draw do
  get 'administrators/new'
  root 'pages#home'

  # Pagine statiche
  get 'logReg', to: 'pages#logReg', as: 'logReg'

  # Autenticazione
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  # Conferma email
  get 'confirm_email', to: 'users#confirm_email'
  get 'confirm/:token', to: 'users#confirm', as: 'confirm_user'

  # Account utente
  get 'accountUtente', to: 'users#accountUtente'

  # Modifica password
  post 'modify_password', to: 'users#modify_password', as: 'modify_password'

  # Password reset
  post 'request_password_reset', to: 'users#request_password_reset'
  get 'edit_password', to: 'users#edit_password', as: 'edit_password'
  patch 'update_password', to: 'users#update_password'

  # Ricerca campi
  get 'search_fields', to: 'fields#search', as: 'search_fields'

  # Risorse
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  
  resources :fields do
    resources :reviews, only: [:index, :new, :create, :destroy]
  end

  # Rotte per il checkout
  post 'checkout/create', to: 'checkout#create', as: 'checkout_create'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'

  # Rotte per partner
  # Rotta per registrazione
  get 'partner_signup', to: 'partners#new'

  # Administrators' routes
  get       'administrator_sign_up',      to: 'administrators#new'
  get       'administrator_log_in',       to: 'sessions#new'
  post      'administrator_log_in',       to: 'sessions#create'
  delete    'administrator_log_out',      to: 'sessions#destroy'
  get       'administrator_dashboard',    to: 'administrators#dashboard'
  get       'administrator_my_profile',   to: 'administrators#myprofile'
  post      'administrator_update',       to: 'administrator#update'
  resources :administrators, only: [:create, :update]

end


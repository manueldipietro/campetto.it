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

  #omniauth
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  # conferma email
  get 'confirm_email', to: 'users#confirm_email'

  #Porta user al suo account
  get 'accountUtente', to: 'users#accountUtente'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  
  get 'checkout/new', to:'checkout#new', as:'new_checkout'
  post 'checkout/create', to: 'checkout#create'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  
  resources :fields  # Questo genera tutte le rotte necessarie per le azioni CRUD

  get 'confirm/:token', to: 'users#confirm', as: 'confirm_user'
end


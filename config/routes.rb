Rails.application.routes.draw do
  root 'pages#home'
  
  get 'logReg', to: 'pages#logReg', as: 'logReg'

  # Rotte per il login
  get 'login', to: 'sessions#new' 
  post 'login', to: 'sessions#create' 
  delete 'logout', to: 'sessions#destroy'

  get 'welcome', to: 'sessions#welcome'

  # Rotte per la registrazione
  get 'signup', to: 'users#new' 
  post 'signup', to: 'users#create' 

  #omniauth
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  # conferma email
  get 'confirm_email', to: 'users#confirm_email'
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
end


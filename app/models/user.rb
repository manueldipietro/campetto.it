class User < ApplicationRecord
    has_secure_password
  
    # Validazioni per l'email
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, on: :create
    
  end
  
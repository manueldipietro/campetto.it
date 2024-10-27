class Partner < ApplicationRecord
    attr_accessor :remember_token
    
    before_save{
        self.name = name.downcase
        self.surname = surname.downcase
        self.email = email.downcase
    }
    
    MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]{2,}\z/i
    GENDER_REGEX = /\A[mfu]\z/i

    has_secure_password

    validates :name, presence: true, length: { minimum: 2, maximum: 50 }
    validates :surname, presence: true, length: { minimum: 2, maximum: 50 }
    validates :gender, format: { with: GENDER_REGEX, allow_blank: true }
    validates :mobile, presence: true, format: { with: /\A\+?[0-9]{10,15}\z/}
    validates :birthdate, presence: true
    validate :must_be_at_least_18_years_old
    validates :email, presence: true, format: { with: MAIL_REGEX }, uniqueness: { case_sensitive: false }
    
    # Returns the hash digest of the given string
    def Partner.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def Partner.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest
    def authenticated?(remember_token)
        BCrypt:Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a partner
    def forget
        update_attribute(:remember_digest, nil)
    end

    private
        def must_be_at_least_18_years_old
            if birthdate.present? && birthdate > 18.years.ago
                errors.add(:birthdate, 'devi avere almeno 18 anni.')
            end
        end

end

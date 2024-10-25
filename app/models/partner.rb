class Partner < ApplicationRecord
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
    
    
    private
        def must_be_at_least_18_years_old
            if birthdate.present? && birthdate > 18.years.ago
                errors.add(:birthdate, 'devi avere almeno 18 anni.')
            end
        end

end

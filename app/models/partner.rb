class Partner < ApplicationRecord
    
    
    #RELATIONS SECTION

    has_many :owned_sports_center, class_name: 'SportsCenter', foreign_key: 'owner_id'
    has_many :partners_sports_centers
    has_many :managed_sports_centers, through: :partners_sports_centers, source: :sports_center

    validate :cannot_be_owner_and_manager

    #--END RELATION SECTION

    
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

        def cannot_be_owner_and_manager
            managed_sports_centers.each do |center|
                if owned_sports_centers.include?(center)
                    errors.add(:base, "You cannot be both the owner and operator of the same SportsCenter.")
                end
            end
        end

end

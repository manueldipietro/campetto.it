class Administrator < ApplicationRecord
    #before_save method to downcase name, surname and email
    before_save{
        self.name = name.downcase
        self.surname = surname.downcase
        self.email = email.downcase
    }

    #Password declaration
    has_secure_password

    #Regex, to refactoring into a common module for application
    MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]{2,}\z/i

    #Attribute validation
    validates :name, presence: true, length: { minimum:2, maximum:50}
    validates :surname, presence: true, length: { minimum:2, maximum:50}
    validates :email, presence: true, length: { maximum: 255 }, format: { with: MAIL_REGEX }, uniqueness: { case_sensitive: false }
    validates :password, length: {minimum: 6}

end


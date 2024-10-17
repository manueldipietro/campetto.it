class Partner < ApplicationRecord
    before_save{
        self.name = name.downcase
        self.surname = surname.downcase
        self.email = email.downcase
    }
    
    ##DA SPOSTARE
    REGEXH_MAIL = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]{2,}\z/i
    REGEXH_GENDER = /\A[mfu]\z/i
    REGEXH_MOBILE = /\A\+\d{1,3}-\d{6,12}\z/
    REGEXH_DATE_DDMMYYYY = /\A(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}\z/

    has_secure_password

    validates :name, presence: true, length: { minimum:2, maximum:50}
    validates :surname, presence: true, length: { minimum:2, maximum:50}
    validates :email, presence: true, length: { maximum: 255 }, format: { with: REGEXH_MAIL }, uniqueness: { case_sensitive: false }
    validates :gender, allow_nil: true, format: { with: REGEXH_GENDER }
    validates :mobile, presence: true, format: { with: REGEXH_MOBILE }
    validates :birthday, presence: true, format: { with: REGEXH_DATE_DDMMYYYY }
    validates :password, length: {minimum: 6}
end

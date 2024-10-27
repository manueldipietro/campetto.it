class PartnerMailer < ApplicationMailer
  default from: "partner-no-reply@campetto.it"

  def account_activation(partner)
    @partner = partner
    mail to: partner.email, subject: "Attivazione account"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.partner_mailer.password_reset.subject
  #
  def password_reset(partner)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

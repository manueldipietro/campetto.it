require 'rails_helper'
require 'capybara/email/rspec'

RSpec.feature "User Registration and Login Flow", type: :feature do
    scenario "User signs up, confirms email, and logs in" do
      #Visita la pagina di registrazione
      visit logReg_path(form: 'signup')
      fill_in "signup_email", with: "test@example.com"
      fill_in "signup_password", with: "Password1!"
      fill_in "conferma_password", with: "Password1!"
      check "policy"
      click_button "Registrati", name: "signup-btn"
    
      # Simula apertura dell'email di conferma
      open_email("test@example.com")
      expect(current_email).to have_content("Benvenuto su Campetto.it!")
      expect(current_email).to have_link("Conferma la tua registrazione")
    
      # Clicca sul link di conferma nell'email
      current_email.click_link "Conferma la tua registrazione"
    
      # Verifica che l'email sia confermata
      user = User.find_by(email: "test@example.com")
      expect(user).not_to be_nil
      expect(user.confirmed_at).not_to be_nil
    
      # Effettua il login manualmente dopo la conferma
      visit logReg_path(form: 'login')
      fill_in "email_login", with: "test@example.com"
      fill_in "password_login", with: "Password1!"
      click_button "Login",id: "login-btn"
      
      puts current_path
      # Verifica che si sia effettuato il login correttamente
      expect(page).to have_current_path(accountUtente_path)

      #Passa alla root page e compila il form di ricerca
      visit root_path
      fill_in "indirizzo", with: "Roma"
      select "Tennis", from: "sport"
      fill_in "data", with: "2024-11-14" 
      click_button "Cerca", id: "cercacampiBtn"

      # Re-clicca sul pulsante "Cerca" nella pagina di ricerca
      select '50', from: 'raggio'
      click_button "Cerca", id: "cercacampiBtn"

      # Verifica che nella pagina di ricerca sia presente il testo "Campi per Tennis"
      expect(page).to have_content("Campi per Tennis")

      # Trova e clicca sulla `field-card` con nome "Tennis Colosseo"
      # Attendi che l'elemento con il testo "Tennis Colosseo" sia visibile
      expect(page).to have_css(".field-card")

      # Ora clicca sull'elemento
      find(".field-card").click


      # Aggiungi qui eventuali ulteriori verifiche dopo il click
      expect(page).to have_content("Tennis Colosseo")
      expect(page).to have_content("Prenota un campo")
      expect(page).to have_content("Slot disponibili per il 14 November 2024:")

      slot_time = "14/11/2024 09:00 - 10:00"
      slot_card = find(".slot-card", text: slot_time)

      # Clicca sul link "Prenota" all'interno della slot-card
      slot_card.click_link('Prenota')

    end
end
  

  
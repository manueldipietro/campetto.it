Given("I am on the signup page") do
    visit logReg_path  # Cambia se la tua rotta è diversa
end
  
When("I fill in {string} with {string}") do |field, value|
    fill_in field, with: value
end

When("I check {string}") do |checkbox|
    check checkbox
end
  
When('I click on {string}') do |button_text|
      find("input[type='submit'][value='#{button_text}']").click
    
end
  
Then("I should see {string}") do |message|
    expect(page).to have_content(message)
end

Then("a user with email {string} should exist") do |email|
    expect(User.find_by(email: email)).to be_present
end

Then('I should not see a new user in the database') do
    expect(User.count).to eq(0) 
    expect(User.find_by(email: "test2@example.com")).to be_nil
end
  
Given("I have registered a user with email {string} and password {string}") do |email, password|
    @user = User.create!(
      email: email,
      password: password,
      password_confirmation: password,
      confirmation_token: SecureRandom.hex(10),  # Simula il token di conferma
      confirmation_sent_at: Time.now
    )
    # Invia l'email di conferma se necessario
end
  
When("I visit the confirmation link with token {string}") do |token|
    visit confirm_user_path(token: token)  
end
  
Given("I have confirmed a user with email {string} and password {string}") do |email, password|
    User.create!(
      email: email,
      password: password,
      password_confirmation: password, 
      confirmed_at: Time.now            
    )
end
  

Then("I should be redirected to login page") do
    expect(current_path).to eq(logReg_path)
end

Then("I should be redirected to account page") do
    expect(current_path).to eq(accountUtente_path)
end
  
When("I visit login page") do
    visit logReg_path
end

Given("I am logged in as a confirmed user with email {string} and password {string}") do |email, password|
    # Crea un utente confermato
    user = User.create!(
      email: email,
      password: password,
      password_confirmation: password,
      confirmed_at: Time.now
    )
  
    # Simula il login impostando la sessione
    page.set_rack_session(user_id: user.id) # Usa la gemma 'rack_session_access' per gestire la sessione
    puts page.get_rack_session
end

When("I visit my account page") do
    visit accountUtente_path
    expect(page).not_to have_current_path(logReg_path)
end
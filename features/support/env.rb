require 'database_cleaner'
require 'cucumber/rails'
require 'capybara/rails'
require 'rack_session_access/capybara'

require_relative 'rack_session_middleware'

require 'webmock/cucumber'

WebMock.disable_net_connect!(allow_localhost: true, allow: ['api.opencagedata.com'])

WebMock.after_request do |request_signature, response|
  puts "#{request_signature} -> #{response.status}"
end

WebMock.enable!

Before do
  stub_request(:post, "https://api.stripe.com/v1/checkout/sessions").
    with(
      body: {"cancel_url"=>"http://localhost:3000/checkout/cancel?slot_id=9406", "line_items"=>[{"price_data"=>{"currency"=>"eur", "product_data"=>{"name"=>"Prenotazione campo: Tennis Colosseo - 05/11/2024 10:00 - 11:00"}, "unit_amount"=>"5000"}, "quantity"=>"1"}], "mode"=>"payment", "payment_method_types"=>["card"], "success_url"=>"http://localhost:3000/checkout/success?payment_intent_id=pi_1GqIC2B2eZvKYlo2C1RMyA0Y&slot_id=9406"},
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Bearer sk_test_51Q2snfRuwVkX58THuP9rRJChV8AFja5GDxHhcoVXNYxAMi4iSjRhbk7s5pZqGE7aAiJGAS0BiOp9UNYeZ0ybB7Zf00jQto6Zpv',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'Idempotency-Key'=>'0955ca86-3b0c-42a4-bd62-dd9faf4dd202',
      'Stripe-Version'=>'2024-09-30.acacia',
      'User-Agent'=>'Stripe/v1 RubyBindings/13.0.0',
      'X-Stripe-Client-User-Agent'=>'{"bindings_version":"13.0.0","lang":"ruby","lang_version":"2.7.2 p137 (2020-10-01)","platform":"x86_64-linux","engine":"ruby","publisher":"stripe","uname":"Linux version 5.15.153.1-microsoft-standard-WSL2 (root@941d701f84f1) (gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Fri Mar 29 23:14:13 UTC 2024","hostname":"DESKTOP-KGCA04R"}'
      }).
    to_return(status: 200, body: '', headers: {})

  stub_request(:post, "https://api.stripe.com/v1/payment_intents").
    with(
      body: {"amount"=>"5000", "automatic_payment_methods"=>{"enabled"=>"true", "allow_redirects"=>"never"}, "currency"=>"eur"},
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Bearer sk_test_51Q2snfRuwVkX58THuP9rRJChV8AFja5GDxHhcoVXNYxAMi4iSjRhbk7s5pZqGE7aAiJGAS0BiOp9UNYeZ0ybB7Zf00jQto6Zpv',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'Idempotency-Key'=>'c76ba859-4bc2-4645-9970-0f4517ca069d',
      'Stripe-Version'=>'2024-09-30.acacia',
      'User-Agent'=>'Stripe/v1 RubyBindings/13.0.0',
      'X-Stripe-Client-User-Agent'=>'{"bindings_version":"13.0.0","lang":"ruby","lang_version":"2.7.2 p137 (2020-10-01)","platform":"x86_64-linux","engine":"ruby","publisher":"stripe","uname":"Linux version 5.15.153.1-microsoft-standard-WSL2 (root@941d701f84f1) (gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Fri Mar 29 23:14:13 UTC 2024","hostname":"DESKTOP-KGCA04R"}'
      }).
      to_return(status: 200, body: '', headers: {})
  
  stub_request(:post, "http://localhost:3000/checkout/create")
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome 
Capybara.app_host = 'http://localhost:3000'
# Configura DatabaseCleaner per test non JavaScript
DatabaseCleaner.strategy = :transaction

# Configura DatabaseCleaner per test JavaScript
Cucumber::Rails::Database.javascript_strategy = :truncation

# Avvia e interrompe DatabaseCleaner automaticamente
Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end

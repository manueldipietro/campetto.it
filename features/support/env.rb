require 'database_cleaner'
require 'cucumber/rails'
require 'capybara/rails'
require 'rack_session_access/capybara'


Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome 

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

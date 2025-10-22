require "database_cleaner/active_record"

DatabaseCleaner.strategy = :transaction
Cucumber::Rails::Database.javascript_strategy = :truncation

Before { DatabaseCleaner.start }
After  { DatabaseCleaner.clean }

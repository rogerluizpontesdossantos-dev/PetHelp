source "https://rubygems.org"

ruby "3.2.0"

gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bcrypt", "~> 3.1"
gem "jwt", "~> 2.7"
gem "aasm", "~> 5.5"
gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.0"
gem "rack-cors", "~> 2.0"
gem "kaminari", "~> 1.2"
gem "active_storage_validations", "~> 1.3"
gem "bootsnap", require: false
gem "image_processing", "~> 1.12"

group :development, :test do
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
  gem "dotenv-rails", "~> 3.1"
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.8"
  gem "bullet", "~> 7.1"
end

group :test do
  gem "shoulda-matchers", "~> 6.1"
  gem "database_cleaner-active_record", "~> 2.1"
end

source "https://rubygems.org"

ruby "3.2.3"

gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "active_model_serializers"
gem "devise_token_auth", ">= 1.2.0", git: "https://github.com/lynndylanhurley/devise_token_auth"
gem "interactor"
gem "torque-postgresql"

group :development, :test do
  gem "dotenv-rails"
  gem "rubocop", require: false
  gem "rspec-rails"
  gem "factory_bot_rails"

  gem "standard", require: false
  gem "rubocop-rails", require: false
  gem "standard-rails", require: false
  gem "rubocop-rspec", require: false

  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "webmock"
  gem "faker"
end

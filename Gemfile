# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
git_source(:sc_gem) do |repo_name|
  "https://758835560c03253fbb10a045b7fa54f6c54f31d8:x-oauth-basic@github.com/StartupCraft/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0'
gem 'puma', '~> 3.11'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'rack-cors', '~> 1.0'

gem 'pg', '~> 1.0'
gem 'sequel-rails', '~> 1.0'
gem 'sequel', '~> 5.8'
# Database enforced timestamps, immutable columns, counter/sum caches, and touch propogation
gem 'sequel_postgresql_triggers', '~> 1.4'

gem 'dry-validation', '~> 0.12'
gem 'dry-monads', '~> 1.0'
gem 'dry-container', '~> 0.6'
gem 'dry-transaction', '~> 0.11'

# Object geocoding (by street, IP address and other)
gem 'geocoder', '~> 1.5'

# Continuation of the acts-as-state-machine
gem 'aasm', '~> 5.0'
# Wrapper for pusher
gem 'pusher', '~> 1.3', '>= 1.3.1'

# Upload files in your Ruby applications
gem 'carrierwave', '~> 1.2', '>= 1.2.2'
# Wraps ffmpeg to read metadata and transcodes videos.
gem 'streamio-ffmpeg', '~> 3.0', '>= 3.0.2'
# Sequel support for CarrierWave
gem 'carrierwave-sequel', '~> 0.1.1'
# Module for 'fog' or as standalone provider to use the AWS in application
gem 'fog-aws', '~> 3.0'
# Manipulate images with minimal use of memory
gem 'mini_magick', '~> 4.8'

gem 'jsonapi-rails', github: 'jsonapi-rb/jsonapi-rails'

gem 'bcrypt', '~> 3.1'
gem 'sequel_secure_password', '~> 0.2'
gem 'knock', '~> 2.1'

# Object oriented authorization for Rails applications
gem 'pundit', '~> 1.1'
gem 'redis', '~> 4.0'

gem 'sidekiq', '~> 5.1'
gem 'sidekiq-statistic', '~> 1.3.0', github: 'davydovanton/sidekiq-statistic'

gem 'sc-webhooks', sc_gem: 'sc-webhooks'
gem 'sc-billing', sc_gem: 'sc-billing', ref: '03d86ef'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', platforms: %i[mri mingw x64_mingw]
  gem 'sequel_pretty_print', '~> 0.2'

  gem 'dotenv-rails', '~> 2.2'
  gem 'rspec-rails', '~> 3.7'
  gem 'ffaker', '~> 2.10'
  gem 'factory_bot_rails', '~> 4.8', require: false
  gem 'rubocop', '~> 0.55'

  # Provides a better error page for Rails and other Rack apps
  gem 'better_errors', '~> 2.4'

  # Retrieve the binding of a method's caller
  gem 'binding_of_caller', '~> 0.8.0'

  # Code coverage for Ruby
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'bundler-audit', '~> 0.6'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0'
end

group :test do
  gem 'rspec_api_documentation', '~> 5.1'
  gem 'database_cleaner', '1.6'
  gem 'json_matchers', '~> 0.9'
  gem 'timecop', '~> 0.9'
  gem 'stripe-ruby-mock', '2.5.3', require: 'stripe_mock'
end

group :staging, :production do
  gem 'aws-ssm-env', '~> 0.1'
  gem 'rack-attack', '~> 5.0'
  gem 'sentry-raven', '~> 2.7'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

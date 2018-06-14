# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot_rails'
require 'rspec_api_documentation/dsl'
require 'json_matchers/rspec'

Dir[Rails.root.join('spec/shared_contexts/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec::Matchers.define_negated_matcher :not_change, :change
JsonMatchers.schema_root = "spec/support/schemas/api"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Helpers
  config.include SerializerHelpers, type: :serializer

  config.include_context 'authenticated_user', :authenticated_user
  config.include_context 'authenticated_admin', :authenticated_admin

  config.before(:suite) do
    FactoryBot.to_create(&:save)
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    case example.metadata[:type]
    when :acceptance
      header "Content-Type", "application/vnd.api+json"
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

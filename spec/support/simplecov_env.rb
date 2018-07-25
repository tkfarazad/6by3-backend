# frozen_string_literal: true

require 'simplecov'

# generating ruby coverage reports
module SimpleCovEnv
  module_function

  def start!
    # return unless ENV['SIMPLECOV']

    configure_profile
    configure_job
    configure_formatters

    SimpleCov.start
  end

  def configure_job
    SimpleCov.use_merging false
  end

  def configure_formatters
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def configure_profile
    SimpleCov.configure do
      load_profile 'rails'
      track_files '{app,lib}/**/*.rb'

      add_filter 'config/initializers/'
      add_filter 'app/jobs'
      add_filter 'app/mailers'

      add_group 'Actions', 'app/actions'
      add_group 'Controllers', 'app/controllers'
      add_group 'Deserializers', 'app/deserializers'
      add_group 'Finders', 'app/finders'
      add_group 'Models', 'app/models'
      add_group 'Operations', 'app/operations'
      add_group 'Policies', 'app/policies'
      add_group 'Schemas', 'app/schemas'
      add_group 'Serializers', 'app/serializers'
      add_group 'Controller Concerns', 'app/controllers/concerns'
      add_group 'Finder Concerns', 'app/finders/concerns'
      add_group 'Model Concerns', 'app/models/concerns'
      add_group 'Libraries', 'lib'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end

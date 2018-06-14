# frozen_string_literal: true

RspecApiDocumentation.configure do |config|
  config.template_path = 'lib'
  config.api_name = '6by3 API'
  config.format = :api_blueprint
  config.request_headers_to_include = ['Authorization', 'Content-Type']
  config.response_headers_to_include = ['Content-Type']
  config.request_body_formatter = :json
end

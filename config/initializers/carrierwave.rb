# frozen_string_literal: true

require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: ENV.fetch('AWS_REGION')
    }
    config.fog_directory = ENV.fetch('AWS_S3_BUCKET_NAME')
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
end

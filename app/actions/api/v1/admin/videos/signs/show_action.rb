# frozen_string_literal: true

module Api::V1::Admin::Videos::Signs
  class ShowAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    map :build_key
    map :sign

    private

    def credentials
      Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID'), ENV.fetch('AWS_SECRET_ACCESS_KEY'))
    end

    def build_key(params)
      folder = ENV.fetch('AWS_S3_VIDEOS_FOLDER')
      file_name = SecureRandom.uuid
      file_extension = params.fetch(:name).split('.').last

      "#{folder}/#{file_name}.#{file_extension}"
    end

    def sign(key)
      Aws::S3::Resource
        .new(region: ENV.fetch('AWS_REGION'))
        .bucket(ENV.fetch('AWS_S3_BUCKET_NAME'))
        .object(key)
        .presigned_url(:put, acl: 'public-read')
    end
  end
end

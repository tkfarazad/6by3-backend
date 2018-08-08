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
      Aws::S3::PresignedPost.new(
        credentials,
        ENV.fetch('AWS_REGION'),
        ENV.fetch('AWS_S3_BUCKET_NAME'),
        key: key,
        acl: 'public-read',
        content_type: 'application/zip',
        success_action_status: '201'
      ).fields
    end
  end
end

# frozen_string_literal: true

module Api::V1::Admin::Videos::Signs
  class ShowAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    map :build_key
    map :sign

    private

    def build_key(params)
      folder = ENV.fetch('AWS_S3_VIDEOS_FOLDER')
      file_name = SecureRandom.uuid
      file_extension = params.fetch(:name).split('.').last

      {
        content_type: params.fetch(:content_type),
        key: "#{folder}/#{file_name}.#{file_extension}"
      }
    end

    def sign(content_type:, key:)
      storage = Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
      )

      options = {path_style: true}
      headers = {'Content-Type' => content_type, 'x-amz-acl' => 'public-read'}
      ttl = 1.hour.from_now.to_time.to_i

      storage.put_object_url(ENV.fetch('AWS_S3_BUCKET_NAME'), key, ttl, headers, options)
    end
  end
end

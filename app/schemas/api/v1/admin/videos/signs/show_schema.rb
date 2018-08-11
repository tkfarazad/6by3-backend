# frozen_string_literal: true

module Api::V1::Admin::Videos::Signs
  ShowSchema = Dry::Validation.Params(BaseSchema) do
    required(:name).filled(:str?)
    required(:size).filled(:int?, included_in?: ::SixByThree::Constants::VIDEO_FILE_SIZE_RANGE)
    required(:content_type).filled(:allowed_video_mime_type?)
  end
end

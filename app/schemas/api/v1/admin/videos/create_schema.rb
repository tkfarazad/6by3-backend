# frozen_string_literal: true

module Api::V1::Admin::Videos
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:name).filled(:str?)
    required(:description).filled(:str?)
    required(:url).filled(:str?)
    required(:content_type).filled(:allowed_video_mime_type?)

    optional(:featured).filled(:bool?)
    optional(:lesson_date).filled(:date_time?)
    optional(:coach_pks).each(:int?)
    optional(:category_id).filled(:int?)
  end
end

# frozen_string_literal: true

module Api::V1::Videos::View
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:video_id).filled(:int?)
  end
end

# frozen_string_literal: true

module Api::V1::Admin::Videos::Thumbnail
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:thumbnail).filled(:image?)
  end
end

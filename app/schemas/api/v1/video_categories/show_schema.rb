# frozen_string_literal: true

module Api::V1::VideoCategories
  ShowSchema = Dry::Validation.Params(BaseSchema) do
    required(:id).filled(:int?)
  end
end

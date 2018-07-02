# frozen_string_literal: true

module Api::V1::Admin::Videos
  ShowSchema = Dry::Validation.Params(BaseSchema) do
    required(:id).filled(:int?)
  end
end

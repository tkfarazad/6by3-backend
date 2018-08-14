# frozen_string_literal: true

module Api::V1::Videos::Featured
  ShowSchema = Dry::Validation.Params(BaseSchema) do
    required(:id).filled(:int?, gt?: 0)
  end
end

# frozen_string_literal: true

module Api::V1::PaymentSources
  CreateSchema = Dry::Validation.Params do
    required(:token).filled
  end
end

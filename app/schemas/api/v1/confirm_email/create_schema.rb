# frozen_string_literal: true

module Api::V1::ConfirmEmail
  CreateSchema = Dry::Validation.Params do
    required(:token).filled
  end
end

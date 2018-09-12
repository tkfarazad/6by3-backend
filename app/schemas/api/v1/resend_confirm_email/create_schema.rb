# frozen_string_literal: true

module Api::V1::ResendConfirmEmail
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:email).filled(:email?)
  end
end

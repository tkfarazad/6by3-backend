# frozen_string_literal: true

module Api::V1::Users
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:email).filled(:email?)
    required(:password).filled(min_size?: 6).confirmation
  end
end

# frozen_string_literal: true

module Api::V1::ChangePassword
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:token).filled
    required(:password).filled(min_size?: 6).confirmation
  end
end

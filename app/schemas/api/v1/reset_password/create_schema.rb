# frozen_string_literal: true

module Api::V1::ResetPassword
  CreateSchema = Dry::Validation.Params do
    required(:email).filled
  end
end

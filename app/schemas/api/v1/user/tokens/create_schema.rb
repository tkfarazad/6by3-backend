# frozen_string_literal: true

module Api::V1::User::Tokens
  CreateSchema = Dry::Validation.Form do
    required(:email).filled
    required(:password).filled
  end
end

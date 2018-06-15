# frozen_string_literal: true

module Api::V1::ConfirmEmail
  CreateSchema = Dry::Validation.Form do
    required(:token).filled
  end
end

# frozen_string_literal: true

module Api::V1::ContactUsEmail
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:name).filled(:str?)
    required(:email).filled(:email?)
    required(:message).filled(:str?)
  end
end

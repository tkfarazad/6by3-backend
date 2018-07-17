# frozen_string_literal: true

module Api::V1::Admin::Users::ResetPassword
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:user_id).filled(:int?)
  end
end

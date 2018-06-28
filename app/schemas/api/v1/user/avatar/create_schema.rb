# frozen_string_literal: true

module Api::V1::User::Avatar
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:avatar).filled(:image?)
  end
end

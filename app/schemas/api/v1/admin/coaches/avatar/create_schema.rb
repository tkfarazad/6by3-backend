# frozen_string_literal: true

module Api::V1::Admin::Coaches::Avatar
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:avatar).filled(:image?)
  end
end

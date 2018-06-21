# frozen_string_literal: true

module Api::V1::User::Avatar
  CreateSchema = Dry::Validation.Params do
    required(:avatar).filled
  end
end

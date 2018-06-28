# frozen_string_literal: true

module Api::V1::User
  UpdateSchema = Dry::Validation.Params(BaseSchema) do
    optional(:fullname).filled(:str?)
    optional(:avatar).filled(:image?)
  end
end

# frozen_string_literal: true

module Api::V1::User
  UpdateSchema = Dry::Validation.Params do
    optional(:fullname).filled(:str?)
    optional(:avatar).filled(:str?)
  end
end

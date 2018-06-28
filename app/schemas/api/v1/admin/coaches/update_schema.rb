# frozen_string_literal: true

module Api::V1::Admin::Coaches
  UpdateSchema = Dry::Validation.Params do
    optional(:avatar).filled(:str?)
    optional(:fullname).filled(:str?)
    optional(:personal_info).filled(:str?)
  end
end

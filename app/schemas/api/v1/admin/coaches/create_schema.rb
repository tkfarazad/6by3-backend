# frozen_string_literal: true

module Api::V1::Admin::Coaches
  CreateSchema = Dry::Validation.Params do
    required(:fullname).filled(:str?)
  end
end

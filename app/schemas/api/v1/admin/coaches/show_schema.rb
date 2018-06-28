# frozen_string_literal: true

module Api::V1::Admin::Coaches
  ShowSchema = Dry::Validation.Params do
    required(:id).filled(:int?)
  end
end

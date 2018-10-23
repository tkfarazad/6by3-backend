# frozen_string_literal: true

module Api::V1::Subscriptions
  CreateSchema = Dry::Validation.Params do
    configure do
      config.type_specs = true
    end

    required(:plan_id, :int).filled(:int?)
    optional(:coupon, Types::Coupon).filled(:str?)
  end
end

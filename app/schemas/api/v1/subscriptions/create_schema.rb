# frozen_string_literal: true

module Api::V1::Subscriptions
  CreateSchema = Dry::Validation.Params do
    required(:plan_id).filled(:int?)
    optional(:coupon).filled(:str?)
  end
end

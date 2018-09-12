# frozen_string_literal: true

module Api::V1::Subscriptions
  class CreateAction < ::Api::V1::BaseAction
    map :deserialize, with: 'params.deserialize'
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    step :create

    private

    def find(input)
      plan = ::SC::Billing::Stripe::Plan.with_pk!(input.fetch(:plan_id))

      input.merge!(plan: plan)
    end

    def create(input)
      subscription_params = prepare_subscription_params(input)

      SC::Billing::Stripe::Subscriptions::CreateOperation
        .new
        .call(current_user, subscription_params)
        .to_result
    end

    def prepare_subscription_params(input)
      {
        items: [{plan: input.fetch(:plan).stripe_id}],
        coupon: input[:coupon]
      }
    end
  end
end

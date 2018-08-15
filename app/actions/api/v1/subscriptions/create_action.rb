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

      input[:plan] = plan

      input
    end

    # TODO: add coupons
    def create(input)
      SC::Billing::Stripe::Subscriptions::CreateOperation
        .new
        .call(current_user, items: [{plan: input.fetch(:plan).stripe_id}])
        .to_result
    end
  end
end

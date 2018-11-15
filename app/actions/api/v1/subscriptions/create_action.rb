# frozen_string_literal: true

module Api::V1::Subscriptions
  class CreateAction < ::Api::V1::BaseAction
    TRIAL_STATUS = SC::Billing::Stripe::Subscription::TRIAL_STATUS
    ACTIVE_STATUS = SC::Billing::Stripe::Subscription::ACTIVE_STATUS

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    check :check_processable
    map :prepare_subscription_params
    step :create

    private

    def find(input)
      plan = ::SC::Billing::Stripe::Plan.with_pk!(input.fetch(:plan_id))

      input.merge!(plan: plan)
    end

    def check_processable(input)
      plan_applicable?(input) && without_active_subscription?
    end

    def prepare_subscription_params(input)
      {
        items: [{plan: input.fetch(:plan).stripe_id}],
        coupon: input[:coupon]
      }
    end

    def create(subscription_params)
      SC::Billing::Stripe::Subscriptions::CreateOperation
        .new
        .call(current_user, subscription_params)
        .to_result
    end

    def plan_applicable?(input)
      input.fetch(:plan).applicable?
    end

    def without_active_subscription?
      SC::Billing::Stripe::Subscription
        .where(user: current_user)
        .where(status: [TRIAL_STATUS, ACTIVE_STATUS])
        .empty?
    end
  end
end

# frozen_string_literal: true

module Api::V1::Subscriptions::Cancel
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:mailer_params]

    try  :find, catch: Sequel::NoMatchingRow
    step :authorize
    step :cancel

    private

    def find(input)
      ::SC::Billing::Stripe::Subscription.with_pk!(input.fetch(:subscription_id))
    end

    def authorize(subscription)
      ::Api::V1::SubscriptionPolicy.new(current_user, subscription).to_monad(&:cancel?)
    end

    def cancel(subscription)
      ::SC::Billing::Stripe::Subscriptions::CancelOperation.new.call(subscription).to_result
    end
  end
end

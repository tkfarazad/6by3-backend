# frozen_string_literal: true

module Billing::Stripe::Webhooks::Customers::Subscriptions
  class UpdateOperation
    def call(event, user)
      customer_data = event.data.object
      return unless customer_data.cancel_at_period_end

      plan = customer_data.items.data.first.plan

      notify(user, plan)
    end

    private

    def notify(user, plan)
      subscription_type = ::SixByThree::Constants::STRIPE[:SUBSCRIPTION_TYPES][plan.interval.to_sym]

      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name,
          price: plan.amount / 100.0,
          subscription_type: subscription_type
        )
        .subscription_cancelled
        .deliver_later
    end
  end
end

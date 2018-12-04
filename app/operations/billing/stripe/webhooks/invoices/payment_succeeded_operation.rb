# frozen_string_literal: true

module Billing::Stripe::Webhooks::Invoices
  class PaymentSucceededOperation
    USER_DELIVERY_METHOD_BY_INTERVAL = {
      'month' => 'monthly_subscription_paid',
      'year' => 'annual_subscription_paid'
    }.freeze

    private_constant :USER_DELIVERY_METHOD_BY_INTERVAL

    def call(invoice:, **_extra_args)
      return if invoice_for_free_usage?(invoice)

      user = invoice.user
      plan = invoice.items.first.plan

      notify(user, plan)
    end

    private

    def invoice_for_free_usage?(invoice)
      invoice.amount_paid.zero? && invoice.paid?
    end

    def notify(user, plan)
      method = USER_DELIVERY_METHOD_BY_INTERVAL[plan.interval]

      return unless method

      ::UserMailer
        .with(
          email: user.email,
          name: user.first_name,
          price: plan.amount / 100.0
        )
        .send(method)
        .deliver_later
    end
  end
end

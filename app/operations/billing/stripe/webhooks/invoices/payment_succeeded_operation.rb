# frozen_string_literal: true

module Billing::Stripe::Webhooks::Invoices
  class PaymentSucceededOperation
    ADMIN_DELIVERY_METHOD_BY_INTERVAL = {
      'month' => 'user_first_monthly_subscription_paid',
      'year' => 'user_first_annual_subscription_paid'
    }.freeze

    USER_DELIVERY_METHOD_BY_INTERVAL = {
      'month' => 'monthly_subscription_paid',
      'year' => 'annual_subscription_paid'
    }.freeze

    private_constant :ADMIN_DELIVERY_METHOD_BY_INTERVAL, :USER_DELIVERY_METHOD_BY_INTERVAL

    def call(invoice:, **_extra_args)
      return if invoice_for_free_usage?(invoice)

      user = invoice.user
      plan = invoice.items.first.plan

      notify_user(user, plan)

      return unless first_paid_invoice?(invoice)
      notify_admin(user, plan)
    end

    private

    def first_paid_invoice?(invoice)
      ::SC::Billing::Stripe::Invoice
        .where(user_id: invoice.user_id, paid: true)
        .where { amount_paid > 0 } # rubocop:disable Style/NumericPredicate
        .exclude(id: invoice.id)
        .empty?
    end

    def invoice_for_free_usage?(invoice)
      invoice.amount_paid.zero? && invoice.paid?
    end

    def notify_admin(user, plan)
      method = ADMIN_DELIVERY_METHOD_BY_INTERVAL[plan.interval]

      return unless method

      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name,
          price: plan.amount / 100.0
        )
        .send(method)
        .deliver_later
    end

    def notify_user(user, plan)
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

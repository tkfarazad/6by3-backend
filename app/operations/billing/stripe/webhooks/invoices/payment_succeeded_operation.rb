# frozen_string_literal: true

module Billing::Stripe::Webhooks::Invoices
  class PaymentSucceededOperation
    DELIVERY_METHOD_BY_INTERVAL = {
      'month' => 'user_first_monthly_transaction',
      'year' => 'user_first_annual_transaction'
    }.freeze

    def call(invoice:, **_extra_args)
      return unless first_paid_invoice?(invoice)
      return if invoice_for_free_usage?(invoice)

      notify(invoice)
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

    def notify(invoice)
      user = invoice.user
      plan = invoice.items.first.plan

      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name,
          price: plan.amount / 100.0
        )
        .send(DELIVERY_METHOD_BY_INTERVAL.fetch(plan.interval))
        .deliver_later
    end
  end
end

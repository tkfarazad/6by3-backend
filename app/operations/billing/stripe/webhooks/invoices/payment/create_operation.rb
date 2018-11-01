# frozen_string_literal: true

module Billing::Stripe::Webhooks::Invoices::Payment
  class CreateOperation
    def call(event, user)
      plan = event.data.object.lines.data.first.plan

      notify(user, plan)
    end

    private

    def notify(user, plan)
      method = 'user_first_monthly_transaction'
      method = 'user_first_annual_transaction' if plan.interval == 'year'

      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name,
          price: plan.amount / 100.0
        )
        .send(method)
        .deliver_later
    end
  end
end

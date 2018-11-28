# frozen_string_literal: true

module Billing::Stripe::Webhooks::Customers::Subscriptions
  class CreateOperation
    def call(**params)
      subscription = fetch_subscription(params.fetch(:event))

      user = params.fetch(:user)
      plan = subscription.plans.first

      if subscription.trialing?
        payment_dates = build_payment_dates(subscription, plan)

        notify_user_free_trial_user_created(user, payment_dates)
        notify_admin_free_trial_user_created(user)
      end

      notify_free_user_created(user) if plan.free?
    end

    private

    def fetch_subscription(event)
      ::SC::Billing::Stripe::Subscription.first(stripe_id: event.data.object.id)
    end

    def build_payment_dates(subscription, plan)
      subscription_end_at = subscription.current_period_end_at
      next_payment_date = subscription_end_at + 1.public_send(plan.interval)

      {
        first_payment_date: subscription_end_at.strftime('%B %d, %Y'),
        next_payment_date: next_payment_date.strftime('%B %d, %Y')
      }
    end

    def notify_user_free_trial_user_created(user, first_payment_date:, next_payment_date:)
      ::UserMailer
        .with(
          email: user.email,
          first_payment_date: first_payment_date,
          next_payment_date: next_payment_date
        )
        .free_trial_start
        .deliver_later
    end

    def notify_admin_free_trial_user_created(user)
      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name
        )
        .free_trial_user_created
        .deliver_later
    end

    def notify_free_user_created(user)
      ::UserMailer
        .with(
          email: user.email,
          name: user.full_name
        )
        .free_user_created
        .deliver_later
    end
  end
end

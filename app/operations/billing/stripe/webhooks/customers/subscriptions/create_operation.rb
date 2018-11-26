# frozen_string_literal: true

module Billing::Stripe::Webhooks::Customers::Subscriptions
  class CreateOperation
    def call(**params)
      subscription = fetch_subscription(params.fetch(:event))

      return unless subscription.present?

      user = params.fetch(:user)

      notify_free_trial_user_created(user) if subscription.trialing?
      notify_free_user_created(user) if subscription.plans&.first&.free?
    end

    private

    def fetch_subscription(event)
      ::SC::Billing::Stripe::Subscription.first(stripe_id: event.data.object.id)
    end

    def notify_free_trial_user_created(user)
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

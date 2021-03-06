# frozen_string_literal: true

module Api::V1::Subscriptions::Cancel
  class CreateAction < ::Api::V1::BaseAction
    CUSTOMERIO_EVENT_TRIAL = 'free-trial-cancelled'
    CUSTOMERIO_EVENT_ACTIVE = 'active-cancelled'

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    tee :enqueue_jobs
    step :cancel
    tee :notify

    private

    def find(input)
      ::SC::Billing::Stripe::Subscription.with_pk!(input.fetch(:subscription_id))
    end

    def authorize(subscription)
      ::Api::V1::SubscriptionPolicy.new(current_user, subscription).to_monad(&:cancel?)
    end

    def enqueue_jobs(subscription)
      if subscription.trialing?
        ::Customerio::TrackJob.perform_later(user_id: current_user.id, event: CUSTOMERIO_EVENT_TRIAL)
      end

      return unless subscription.active?

      ::Customerio::TrackJob.perform_later(user_id: current_user.id, event: CUSTOMERIO_EVENT_ACTIVE)
    end

    def cancel(subscription)
      ::SC::Billing::Stripe::Subscriptions::CancelOperation.new.call(subscription).to_result
    end

    def notify(subscription)
      user = subscription.user

      ::UserMailer
        .with(
          email: user.email,
          name: user.full_name,
          end_date: subscription.current_period_end_at.strftime('%B %d, %Y')
        )
        .subscription_cancelled
        .deliver_later
    end
  end
end

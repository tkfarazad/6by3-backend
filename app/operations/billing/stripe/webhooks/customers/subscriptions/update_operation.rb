# frozen_string_literal: true

module Billing::Stripe::Webhooks::Customers::Subscriptions
  class UpdateOperation
    CUSTOMERIO_EVENT = 'trial-ended'

    def call(**params)
      previous_attributes = params.fetch(:event).data.previous_attributes

      return unless previous_attributes.respond_to?(:status) && previous_attributes.status == 'trialing'
      return unless previous_attributes.current_period_end < Time.now.to_i

      subscription = params.fetch(:subscription)

      track_customerio(subscription.user)
    end

    private

    def track_customerio(user)
      ::Customerio::TrackJob.perform_later(user_id: user.id, event: CUSTOMERIO_EVENT)
    end
  end
end

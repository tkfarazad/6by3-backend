# frozen_string_literal: true

module Billing::Stripe::Webhooks::Customers::Subscriptions
  class CreateOperation
    def call(**params)
      notify(params.fetch(:user))
    end

    private

    def notify(user)
      ::AdminMailer
        .with(
          email: user.email,
          name: user.full_name
        )
        .free_trial_user_created
        .deliver_later
    end
  end
end

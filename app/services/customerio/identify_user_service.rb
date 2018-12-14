# frozen_string_literal: true

module Customerio
  class IdentifyUserService
    include Import['customerio.client']

    def call(user:)
      client.identify(
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        created_at: user.created_at.to_i,
        email_confirmed: user.email_confirmed_at.present?,
        card_added: card_added?(user),
        plan_type: user.plan_type
      )
    end

    private

    def card_added?(user)
      !user.payment_sources_dataset.empty?
    end
  end
end

# frozen_string_literal: true

module Customerio
  class IdentifyUserService
    include Import['customerio.client']

    def call(user:)
      client.identify(
        id: user.id,
        email: user.email,
        created_at: user.created_at.to_i,
        email_confirmed: user.email_confirmed_at.present?,
        card_added: card_added?(user)
      )
    end

    private

    def card_added?(user)
      !user.payment_sources_dataset.empty?
    end
  end
end

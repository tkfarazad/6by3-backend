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
        credit_card_added: credit_card_added?(user)
      )
    end

    private

    def credit_card_added?(user)
      !user.payment_sources_dataset.empty?
    end
  end
end

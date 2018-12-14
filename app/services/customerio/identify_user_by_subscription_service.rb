# frozen_string_literal: true

module Customerio
  class IdentifyUserBySubscriptionService
    def call(subscription:, **_attrs)
      return if subscription.nil?

      ::Customerio::IdentifyUserService.new.call(user: subscription.user)
    end
  end
end

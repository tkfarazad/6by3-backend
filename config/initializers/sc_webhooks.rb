# frozen_string_literal: true

SC::Webhooks.configure do |config|
  config.handlers = {
    ENV.fetch('STRIPE_WEBHOOK_PATH') => ::SC::Billing::Webhooks::StripeAction
  }
end

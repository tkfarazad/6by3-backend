# frozen_string_literal: true

SC::Billing.configure do |config|
  config.stripe_api_key = ENV.fetch('STRIPE_API_KEY')
  config.stripe_webhook_secret = ENV.fetch('STRIPE_WEBHOOK_SECRET')
  config.user_model_name = 'User'
  config.available_events = [
    'customer.created',
    'customer.updated',
    'product.created',
    'plan.created',
    'plan.updated',
    'customer.source.created',
    'customer.source.updated',
    'customer.source.deleted',
    'customer.subscription.created',
    'customer.subscription.updated',
    'customer.subscription.deleted'
  ]
end

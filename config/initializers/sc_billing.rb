# frozen_string_literal: true

SC::Billing.configure do |config| # rubocop:disable Metrics/BlockLength
  config.stripe_api_key = ENV.fetch('STRIPE_API_KEY')
  config.stripe_webhook_secret = ENV.fetch('STRIPE_WEBHOOK_SECRET')
  config.user_model_name = 'User'

  config.registration_source[:follow?] = true
  config.registration_source.enum_name = :users_created_in_types
  config.registration_source.field_name = :created_in

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
    'customer.subscription.deleted',
    'invoice.created',
    'invoice.updated',
    'invoice.payment_succeeded'
  ]

  config.event_hooks = {
    'customer.subscription.created' => {
      'after' => [
        ActualizeUserPlanTypeService,
        Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation,
        Customerio::IdentifyUserBySubscriptionService
      ]
    },
    'customer.subscription.updated' => {
      'after' => [
        ActualizeUserPlanTypeService,
        Billing::Stripe::Webhooks::Customers::Subscriptions::UpdateOperation,
        Customerio::IdentifyUserBySubscriptionService
      ]
    },
    'customer.subscription.deleted' => {
      'after' => [
        ActualizeUserPlanTypeService,
        Customerio::IdentifyUserBySubscriptionService
      ]
    },
    'invoice.payment_succeeded' => {
      'after' => Billing::Stripe::Webhooks::Invoices::PaymentSucceededOperation
    }
  }
end

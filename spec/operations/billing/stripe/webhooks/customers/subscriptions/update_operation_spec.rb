# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::UpdateOperation, :stripe do
  subject(:subscription_updated) do
    described_class.new.call(event: event_updated, subscription: subscription)
  end

  subject(:subscription_cancelled) do
    described_class.new.call(event: event_cancelled, subscription: subscription)
  end

  let(:email) { FFaker::Internet.email }
  let!(:user) { create(:user, email: email, stripe_customer_id: event_cancelled.data.object.id) }
  let(:subscription) { create(:stripe_subscription, user: user) }
  let(:event_updated) do
    StripeMock.mock_webhook_event('customer.subscription.updated')
  end
  let(:event_cancelled) do
    StripeMock.mock_webhook_event(
      'customer.subscription.updated',
      email: email,
      amount: 100,
      cancel_at_period_end: true
    )
  end

  context 'when customer subscription updated' do
    it 'subscription was not cancelled' do
      expect(subscription_updated).to eq nil
    end

    it 'subscription was cancelled' do
      expect { subscription_cancelled }.to(
        have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          .with(
            'AdminMailer',
            'subscription_cancelled',
            'deliver_now',
            hash_including(:email, :name, :price, :subscription_type)
          )
      )
    end
  end
end

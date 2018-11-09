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
      expect(subscription_cancelled.subject).to eq('Subscription Cancelled')
      expect(subscription_cancelled.to).to eq(['support@6by3studio.com'])
      expect(subscription_cancelled.body.encoded).to include(user.full_name)
      expect(subscription_cancelled.body.encoded).to include(user.email)
      expect(subscription_cancelled.body.encoded).to include('1.0')
      expect(subscription_cancelled.body.encoded).to include('Monthly')
    end
  end
end

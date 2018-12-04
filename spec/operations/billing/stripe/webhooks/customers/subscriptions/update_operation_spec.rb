# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::UpdateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event: event, subscription: subscription)
  end

  let!(:user) { create(:user, stripe_customer_id: event.data.object.id) }
  let(:subscription) { create(:stripe_subscription, user: user) }
  let(:event) { StripeMock.mock_webhook_event('customer.subscription.updated') }

  context 'when customer subscription updated' do
    it 'status was not changed' do
      expect(call).to eq nil
    end

    context 'status changed but not from trialing' do
      before do
        event.data.previous_attributes['status'] = 'active'
      end

      it 'does not enqueue job' do
        expect(call).to eq nil
      end
    end

    context 'trial ended' do
      before do
        event.data.previous_attributes['status'] = 'trialing'
        event.data.previous_attributes['current_period_end'] = (Time.now - 1.day).to_i
      end

      it 'enqueue job' do
        expect { call }.to(
          have_enqueued_job(::Customerio::TrackJob).with(user_id: user.id, event: 'trial-ended')
        )
      end
    end
  end
end

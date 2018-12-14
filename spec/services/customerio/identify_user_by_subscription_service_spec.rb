# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUserBySubscriptionService, :customerio do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(subscription: subscription)
    end

    let(:subscription) { create(:stripe_subscription) }

    it 'identifies user in customerio' do
      allow(customerio_client).to receive(:identify)

      call

      expect(customerio_client).to(
        have_received(:identify).with(
          hash_including(
            :id,
            :email,
            :first_name,
            :last_name,
            :created_at,
            :email_confirmed,
            :card_added,
            :plan_type
          )
        )
      )
    end

    context 'when subscription is nil' do
      let(:subscription) { nil }

      it 'does not identify user in customerio' do
        allow(customerio_client).to receive(:identify)

        call

        expect(customerio_client).not_to have_received(:identify)
      end
    end
  end
end

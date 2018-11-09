# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event: event, user: user)
  end

  let!(:user) { create(:user) }
  let(:event) { StripeMock.mock_webhook_event('customer.created') }

  context 'when customer created' do
    it 'enqueues email' do
      have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
        .with('AdminMailer', 'free_trial_user_created', 'deliver_now', hash_including(:email, :name))
    end
  end
end

# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event: event, user: user)
  end

  let!(:user) { create(:user) }
  let(:event) { StripeMock.mock_webhook_event('customer.created') }

  context 'when customer created' do
    it 'creates subscription' do
      expect(result.subject).to eq('New User Registered on Free 7 Days Trial')
      expect(result.to).to eq(['support@6by3studio.com'])
      expect(result.body.encoded).to include(user.full_name)
      expect(result.body.encoded).to include(user.email)
    end
  end
end

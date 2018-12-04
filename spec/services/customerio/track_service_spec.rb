# frozen_string_literal: true

RSpec.describe Customerio::TrackService, :customerio do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user_id: user.id, event: event, **attributes)
    end

    let(:user) { create(:user) }
    let(:event) { 'event_name' }
    let(:attributes) { {a: 1} }

    it 'identifies user in customerio' do
      allow(customerio_client).to receive(:track)

      call

      expect(customerio_client).to(
        have_received(:track).with(
          user.id, event, **attributes
        )
      )
    end
  end
end

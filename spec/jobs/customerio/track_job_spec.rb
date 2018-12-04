# frozen_string_literal: true

RSpec.describe Customerio::TrackJob do
  describe '.perform' do
    let(:user) { create(:user) }
    let(:event) { 'event_name' }
    let(:attributes) { {a: 1} }

    subject(:perform) do
      described_class.perform_now(user_id: user.id, event: event, **attributes)
    end

    let(:track_service) { instance_double('Customerio::TrackService') }

    before do
      allow(Customerio::TrackService).to receive(:new).and_return(track_service)
    end

    it 'calls service' do
      allow(track_service).to receive(:call)

      perform

      expect(track_service).to have_received(:call).with(user_id: user.id, event: event, **attributes)
    end
  end
end

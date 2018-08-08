# frozen_string_literal: true

RSpec.describe ProcessVideoDataJob do
  describe '.perform' do
    let(:video) { create(:video) }

    subject(:perform) do
      described_class.perform_now(video_id: video.id)
    end

    it 'calls service' do
      expect_any_instance_of(ProcessVideoDataService).to receive(:call).with(video)

      perform
    end
  end
end

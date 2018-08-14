# frozen_string_literal: true

RSpec.describe ProcessVideoDataService do
  let!(:video) { create(:video, duration: 0) }
  let(:fixture) { file_fixture('video.mp4') }

  describe '#call' do
    before(:context) { start_web_server }
    after(:context) { stop_web_server }

    subject(:call) do
      described_class.new.call(video)
    end

    it 'updates video attributes' do
      expect { call }.to(
        change { video.duration }.from(0).to(6)
        .and(change { video.thumbnail.present? }.from(false).to(true))
      )

      expect(pusher_events.count).to eq(1)
      expect(pusher_events.first[:channels]).to eq ["videos.#{video.id}"]
      expect(pusher_events.first[:event]).to eq 'processing'
      expect(pusher_events.first[:data]).to eq 'status' => 'finished'
    end
  end
end

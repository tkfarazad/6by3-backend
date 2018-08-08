# frozen_string_literal: true

RSpec.describe ProcessVideoDataService do
  let!(:video) { create(:video, duration: 0) }
  let(:fixture) { file_fixture('video.mp4') }

  describe '#call' do
    before do
      stub_request(:any, video.url).to_return(status: 200, body: fixture, headers: {})
    end

    it 'sends letter' do
      expect { described_class.new.call(video) }.to change { video.reload.duration }.from(0).to(6.134)
    end
  end
end

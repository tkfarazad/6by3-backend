# frozen_string_literal: true

# require 'net/http'
require 'webrick'

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
    end
  end
end

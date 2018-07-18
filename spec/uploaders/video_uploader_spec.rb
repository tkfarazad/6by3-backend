# frozen_string_literal: true

require 'carrierwave/test/matchers'

RSpec.describe VideoUploader do
  include CarrierWave::Test::Matchers

  let!(:video) { create(:video) }
  let(:uploader) { described_class.new(video, :content) }

  def upload_file(path)
    File.open("spec/fixtures/files/#{path}") do |file|
      uploader.store!(file)
    end
  end

  after do
    uploader.remove!
  end

  context 'when invalid' do
    it 'raises error of image invalid format' do
      expect { upload_file('video.ogv') }.to raise_error(CarrierWave::IntegrityError)
    end
  end
end

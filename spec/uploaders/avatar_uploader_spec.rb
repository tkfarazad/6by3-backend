# frozen_string_literal: true

require 'carrierwave/test/matchers'

RSpec.describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let!(:user) { create(:user) }
  let(:uploader) { described_class.new(user, :avatar) }

  def upload_file(path)
    File.open("spec/fixtures/files/#{path}") do |file|
      uploader.store!(file)
    end
  end

  after do
    uploader.remove!
  end

  context 'when valid' do
    it 'file is uploaded' do
      upload_file('image.png')

      expect(uploader).to be_format('png')
    end
  end

  context 'when invalid' do
    it 'raises error of image invalid format' do
      expect { upload_file('image.svg') }.to raise_error(CarrierWave::IntegrityError)
    end
  end
end

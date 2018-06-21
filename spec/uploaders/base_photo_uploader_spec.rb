# frozen_string_literal: true

RSpec.describe BasePhotoUploader do
  let!(:user) { create(:user) }
  let(:uploader) { described_class.new(user, :avatar) }

  subject(:upload) do
    upload_file('avatar.png')
  end

  def upload_file(path)
    File.open("spec/fixtures/files/#{path}") do |file|
      uploader.store!(file)
    end
  end

  def define_uploader_extension_whitelist
    described_class.define_method(:extension_whitelist) do
      ['png']
    end
  end

  after do
    uploader.remove!
  end

  context 'was not configured' do
    it 'throws error when options are not configured' do
      expect { upload }.to raise_error(ArgumentError, 'Provide available photo extensions')

      define_uploader_extension_whitelist

      expect { upload }.to raise_error(ArgumentError, 'Provide directory where files will be stored')
    end
  end
end

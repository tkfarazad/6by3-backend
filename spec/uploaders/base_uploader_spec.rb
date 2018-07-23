# frozen_string_literal: true

RSpec.describe BaseUploader do
  let!(:user) { create(:user) }
  let(:uploader) { described_class.new(user, :avatar) }

  subject(:upload) do
    upload_file('image.png')
  end

  def upload_file(path)
    File.open("spec/fixtures/files/#{path}") do |file|
      uploader.store!(file)
    end
  end

  def define_uploader_method(method, content)
    described_class.define_method(method) do
      content
    end
  end

  after do
    uploader.remove!
  end

  context 'was not configured' do
    it 'throws error when options are not configured' do
      expect { upload }.to raise_error(ArgumentError, 'Provide available file extensions')

      define_uploader_method(:extension_whitelist, ['png'])

      expect { upload }.to raise_error(ArgumentError, 'Provide minimum and maximum file size range')

      define_uploader_method(:size_range, 1..2.megabytes)

      expect { upload }.to raise_error(ArgumentError, 'Provide directory where files will be stored')
    end
  end
end

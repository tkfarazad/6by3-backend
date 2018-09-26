# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::Thumbnail::UpdateSchema do
  describe 'thumbnail' do
    def schema(thumbnail)
      described_class.call(thumbnail: thumbnail)
    end

    it 'returns failure when empty' do
      result = schema('')

      expect(result).to be_failure
      expect(result.errors).to eq(thumbnail: ['must be filled'])
    end

    it 'returns failure when too big' do
      thumbnail = fixture_file_upload('spec/fixtures/files/image.png', 'image/png')

      allow(thumbnail).to receive(:size) { 1.exabyte }

      result = schema(thumbnail)

      expect(result).to be_failure
      expect(result.errors).to eq(
        thumbnail: [
          "size must be within #{::SixByThree::Constants::THUMBNAIL_FILE_SIZE_RANGE.min}" \
          " - #{::SixByThree::Constants::THUMBNAIL_FILE_SIZE_RANGE.max}"
        ]
      )
    end

    it 'returns failure when too small' do
      thumbnail = fixture_file_upload('spec/fixtures/files/image.png', 'image/png')

      allow(thumbnail).to receive(:size) { 0 }

      result = schema(thumbnail)

      expect(result).to be_failure
      expect(result.errors).to eq(
        thumbnail: [
          "size must be within #{::SixByThree::Constants::THUMBNAIL_FILE_SIZE_RANGE.min}" \
          " - #{::SixByThree::Constants::THUMBNAIL_FILE_SIZE_RANGE.max}"
        ]
      )
    end

    it 'returns success' do
      result = schema(fixture_file_upload('spec/fixtures/files/image.png', 'image/png'))

      expect(result).to be_success
    end
  end
end

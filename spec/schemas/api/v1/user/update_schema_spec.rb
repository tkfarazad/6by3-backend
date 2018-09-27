# frozen_string_literal: true

RSpec.describe Api::V1::User::UpdateSchema do
  describe 'attributes' do
    def schema(**options)
      described_class.call(options)
    end

    describe 'first_name' do
      it 'returns failure' do
        result = schema(first_name: '')

        expect(result).to be_failure
        expect(result.errors).to eq(first_name: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(first_name: FFaker::Name.first_name)).to be_success
      end
    end

    describe 'last_name' do
      it 'returns failure' do
        result = schema(last_name: '')

        expect(result).to be_failure
        expect(result.errors).to eq(last_name: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(last_name: FFaker::Name.last_name)).to be_success
      end
    end
  end

  describe 'avatar' do
    def schema(avatar)
      described_class.call(avatar: avatar)
    end

    it 'returns failure when empty' do
      result = schema('')

      expect(result).to be_failure
      expect(result.errors).to eq(avatar: ['must be filled'])
    end

    it 'returns failure when too big' do
      avatar = fixture_file_upload('spec/fixtures/files/image.png', 'image/png')

      allow(avatar).to receive(:size) { 1.exabyte }

      result = schema(avatar)

      expect(result).to be_failure
      expect(result.errors).to eq(
        avatar: [
          "size must be within #{::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE.min}" \
          " - #{::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE.max}"
        ]
      )
    end

    it 'returns failure when too small' do
      avatar = fixture_file_upload('spec/fixtures/files/image.png', 'image/png')

      allow(avatar).to receive(:size) { 0 }

      result = schema(avatar)

      expect(result).to be_failure
      expect(result.errors).to eq(
        avatar: [
          "size must be within #{::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE.min}" \
          " - #{::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE.max}"
        ]
      )
    end

    it 'returns success' do
      result = schema(fixture_file_upload('spec/fixtures/files/image.png', 'image/png'))

      expect(result).to be_success
    end
  end
end

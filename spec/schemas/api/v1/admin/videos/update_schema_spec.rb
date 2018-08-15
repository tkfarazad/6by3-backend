# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::UpdateSchema do
  describe 'attributes' do
    def schema(**options)
      described_class.call(options)
    end

    def valid_schema(**options)
      described_class.call(options.merge(
                             name: FFaker::Video.name,
                             description: FFaker::Book.description,
                             url: FFaker::Internet.http_url,
                             content_type: ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.sample
      ))
    end

    it 'returns success when empty' do
      result = schema

      expect(result).to be_success
    end

    it 'returns failure when invalid' do
      result = schema(name: 1, description: 1, url: 1, content_type: 1)

      expect(result).to be_failure
      expect(result.errors).to eq(
        name: ['must be a string'],
        description: ['must be a string'],
        url: ['must be a string'],
        content_type: ['incorrect video content type']
      )
    end

    it 'returns failure when invalid' do
      result = valid_schema(featured: {}, lesson_date: 'lorem', coach_pks: 0, category_id: 'lorem')

      expect(result).to be_failure
      expect(result.errors).to eq(
        featured: ['must be filled'],
        lesson_date: ['must be a date time'],
        coach_pks: ['must be an array'],
        category_id: ['must be an integer']
      )
    end

    it 'returns success when valid' do
      # rubocop:disable Style/DateTime
      expect(valid_schema(featured: true, lesson_date: DateTime.new, coach_pks: [1, 2], category_id: 1)).to be_success
      # rubocop:enable Style/DateTime
    end
  end
end

# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::UpdateSchema do
  describe 'attributes' do
    def schema(**options)
      described_class.call(options)
    end

    describe 'fullname' do
      it 'returns failure' do
        result = schema(fullname: '')

        expect(result).to be_failure
        expect(result.errors).to eq(fullname: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(fullname: FFaker::Name.name)).to be_success
      end
    end

    describe 'personal_info' do
      it 'returns failure' do
        result = schema(personal_info: '')

        expect(result).to be_failure
        expect(result.errors).to eq(personal_info: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(personal_info: FFaker::Book.description)).to be_success
      end
    end

    describe 'certifications' do
      it 'returns failure when not array' do
        result = schema(certifications: 1)

        expect(result).to be_failure
        expect(result.errors).to eq(certifications: ['must be an array'])
      end

      it 'returns failure when array of not strings' do
        result = schema(certifications: [1])

        expect(result).to be_failure
        expect(result.errors).to eq(certifications: {0 => ['must be a string']})
      end

      it 'returns success' do
        expect(schema(certifications: [FFaker::Job.title])).to be_success
      end
    end
  end
end
